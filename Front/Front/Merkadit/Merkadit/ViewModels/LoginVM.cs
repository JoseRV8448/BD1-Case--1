namespace Merkadit.ViewModels
{
    public class LoginVM
    {
        public string password_hash { get; set; } = null!;
        public string? email { get; set; }
    }
}
