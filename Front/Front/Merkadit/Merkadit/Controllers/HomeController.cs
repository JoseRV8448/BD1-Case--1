using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authentication;

namespace Merkadit.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult Index()
        {
            // Siempre inicializamos en false
            ViewBag.EsAdmin = false;

            if (User.Identity != null && User.Identity.IsAuthenticated)
            {
                // siempre revisa si el usuario tiene el rol Admin
                ViewBag.EsAdmin = User.IsInRole("Admin");
            }

            return View();
        }

        public async Task<IActionResult> Salir()
        {
            await HttpContext.SignOutAsync();
            return RedirectToAction("Login", "Acceso");
        }
    }
}
