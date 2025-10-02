namespace Merkadit.ViewModels
{
    public class UserAccountsVM
    {
        public string username { get; set; } = null!;
        public string password_hash { get; set; } = null!;
        public string ConfirmarClave { get; set; } = null!;

        public string? email { get; set; }
        public string? full_name { get; set; }      
    }
}
