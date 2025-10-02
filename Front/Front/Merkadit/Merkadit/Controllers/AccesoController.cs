using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Merkadit.Data;
using Merkadit.Models;
using Merkadit.ViewModels;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication;
using System.Security.Claims;

namespace Merkadit.Controllers
{
    public class AccesoController : Controller
    {
        private readonly AppDBContext _appDBContext;

        public AccesoController(AppDBContext context)
        {
            _appDBContext = context;
        }

        [HttpGet]
        public IActionResult Login()
        {
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> Login(LoginVM modelo)
        {
            var userAccounts_encontrado = await _appDBContext.UserAccounts
                .FirstOrDefaultAsync(u => u.email == modelo.email);

            if (userAccounts_encontrado == null ||
                !BCrypt.Net.BCrypt.Verify(modelo.password_hash, userAccounts_encontrado.password_hash))
            {
                ViewData["Mensaje"] = "Credenciales inválidas, por favor intenta de nuevo.";
                return View(modelo);
            }

            // aca se Obtiene el rol del usuario
            var rol = (from ur in _appDBContext.UserRoles
                       join r in _appDBContext.Roles on ur.role_id equals r.Id
                       where ur.user_id == userAccounts_encontrado.Id
                       select r.name).FirstOrDefault();

            // aqui se insertan los Claims (nombre, id y rol)
            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.Name, userAccounts_encontrado.username),
                new Claim(ClaimTypes.NameIdentifier, userAccounts_encontrado.Id.ToString()),
                new Claim(ClaimTypes.Role, rol ?? "User") // si no tiene rol, default "User"
            };

            var claimsIdentity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);

            await HttpContext.SignInAsync(
                CookieAuthenticationDefaults.AuthenticationScheme,
                new ClaimsPrincipal(claimsIdentity),
                new AuthenticationProperties
                {
                    IsPersistent = true,
                    ExpiresUtc = DateTime.UtcNow.AddHours(1)
                });

            return RedirectToAction("Index", "Home");
        }

        [HttpGet]
        public IActionResult Registrarse()
        {
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> Registrarse(UserAccountsVM modelo)
        {
            if (modelo.password_hash != modelo.ConfirmarClave)
            {
                ViewData["Mensaje"] = "Las contraseñas no coinciden, por favor revísalas.";
                return View(modelo);
            }

            if (await _appDBContext.UserAccounts.AnyAsync(u => u.username == modelo.username))
            {
                ViewData["Mensaje"] = "El nombre de usuario ya está en uso.";
                return View(modelo);
            }

            var userAccounts = new UserAccounts
            {
                full_name = modelo.full_name,
                username = modelo.username,
                email = modelo.email,
                password_hash = BCrypt.Net.BCrypt.HashPassword(modelo.password_hash),
                is_active = true,
                created_at = DateTime.Now,
                updated_at = DateTime.Now
            };

            await _appDBContext.UserAccounts.AddAsync(userAccounts);
            await _appDBContext.SaveChangesAsync();

            // aca se Asigna el rol por defecto (User)
            var rolPorDefecto = await _appDBContext.Roles
                .FirstOrDefaultAsync(r => r.name == "User");

            if (rolPorDefecto != null)
            {
                var userRole = new UserRoles
                {
                    user_id = userAccounts.Id,
                    role_id = rolPorDefecto.Id
                };

                await _appDBContext.UserRoles.AddAsync(userRole);
                await _appDBContext.SaveChangesAsync();
            }

            if (userAccounts.Id != 0)
                return RedirectToAction("Login", "Acceso");

            ViewData["Mensaje"] = "No se pudo crear el usuario, inténtalo de nuevo.";
            return View(modelo);
        }
    }
}
