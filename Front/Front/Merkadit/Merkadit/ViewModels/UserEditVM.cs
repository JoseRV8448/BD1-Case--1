namespace Merkadit.ViewModels
{
    public class UserEditVM
    {
        public long Id { get; set; }
        public string username { get; set; } = "";
        public string? full_name { get; set; }
        public string? email { get; set; }
        public bool is_active { get; set; }
        public long RoleId { get; set; }
    }

}

