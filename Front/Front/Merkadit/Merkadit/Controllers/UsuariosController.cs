using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Merkadit.Data;
using Merkadit.Models;
using Merkadit.ViewModels;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace Merkadit.Controllers
{
    [Authorize(Roles = "Admin")] // Solo administradores pueden manejar usuarios
    public class UsuariosController : Controller
    {
        private readonly AppDBContext _context;

        public UsuariosController(AppDBContext context)
        {
            _context = context;
        }

        // GET: Usuarios
        public IActionResult Index()
        {
            var usuarios = _context.UserAccounts
                .Include(u => u.UserRoles)
                .ThenInclude(ur => ur.Role) // aqui Trae también los roles
                .ToList();

            return View(usuarios);
        }

        // GET: Usuarios/Create
        public IActionResult Create()
        {
            var vm = new UserAccountsVM();
            ViewBag.Roles = _context.Roles.ToList();
            return View(vm); // aca pasamos el VM
        }


        // POST: Usuarios/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(UserAccountsVM modelo)
        {
            if (!ModelState.IsValid)
                return View(modelo);

            if (modelo.password_hash != modelo.ConfirmarClave)
            {
                ViewData["Mensaje"] = "Las contraseñas no coinciden.";
                return View(modelo);
            }

            if (await _context.UserAccounts.AnyAsync(u => u.username == modelo.username))
            {
                ViewData["Mensaje"] = "El nombre de usuario ya está en uso.";
                return View(modelo);
            }

            var user = new UserAccounts
            {
                full_name = modelo.full_name,
                username = modelo.username,
                email = modelo.email,
                password_hash = BCrypt.Net.BCrypt.HashPassword(modelo.password_hash),
                is_active = true,
                created_at = DateTime.Now,
                updated_at = DateTime.Now
            };

            _context.UserAccounts.Add(user);
            await _context.SaveChangesAsync();

            // se asigna rol por defecto
            var rolPorDefecto = await _context.Roles.FirstOrDefaultAsync(r => r.name == "User");
            if (rolPorDefecto != null)
            {
                var userRole = new UserRoles
                {
                    user_id = user.Id,
                    role_id = rolPorDefecto.Id
                };

                _context.UserRoles.Add(userRole);
                await _context.SaveChangesAsync();
            }

            return RedirectToAction(nameof(Index));
        }

        // GET: Usuarios/Delete/
        public async Task<IActionResult> Delete(long id)
        {
            var user = await _context.UserAccounts.FindAsync(id);

            if (user == null)
                return NotFound();

            //  en vez de eliminar, marcamos como inactivo
            user.is_active = false;
            user.updated_at = DateTime.Now;

            _context.UserAccounts.Update(user);
            await _context.SaveChangesAsync();

            // Redirige de nuevo al listado
            return RedirectToAction(nameof(Index));
        }

        // GET: Usuarios/Edit/5
        public async Task<IActionResult> Edit(long id)
        {
            var user = await _context.UserAccounts
                .Include(u => u.UserRoles)
                .FirstOrDefaultAsync(u => u.Id == id);

            if (user == null)
                return NotFound();

            var modelo = new UserEditVM
            {
                Id = user.Id,
                username = user.username,
                email = user.email,
                full_name = user.full_name,
                is_active = user.is_active,
                RoleId = user.UserRoles.FirstOrDefault()?.role_id ?? 0
            };

            // Aquí convertimos Roles en SelectList
            ViewBag.Roles = new SelectList(
                _context.Roles.ToList(),  
                "Id",                    
                "name",                   
                modelo.RoleId             
            );

            return View(modelo);
        }


        // POST: Usuarios/Edit/
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(long id, UserEditVM modelo)
        {
            if (id != modelo.Id)
                return NotFound();

            if (ModelState.IsValid)
            {
                var user = await _context.UserAccounts
                    .Include(u => u.UserRoles)
                    .FirstOrDefaultAsync(u => u.Id == id);

                if (user == null)
                    return NotFound();

                // se actualizan los campos básicos
                user.username = modelo.username;
                user.email = modelo.email;
                user.full_name = modelo.full_name;
                user.is_active = modelo.is_active;

                // se Maneja el rol (eliminar el actual y asignar el nuevo)
                var currentRole = user.UserRoles.FirstOrDefault();
                if (currentRole != null)
                {
                    _context.UserRoles.Remove(currentRole);
                }

                var newUserRole = new UserRoles
                {
                    user_id = user.Id,
                    role_id = modelo.RoleId   
                };
                _context.UserRoles.Add(newUserRole);

                try
                {
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!_context.UserAccounts.Any(e => e.Id == user.Id))
                        return NotFound();
                    else
                        throw;
                }

                return RedirectToAction(nameof(Index));
            }

            // se vulvemos a pasar la lista de roles si hay error de validación
            ViewBag.Roles = new SelectList(_context.Roles.ToList(), "Id", "name", modelo.RoleId);
            return View(modelo);

        }





    }
}
