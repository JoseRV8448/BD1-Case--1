using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace Merkadit.Data
{
    public class AppDBContextFactory : IDesignTimeDbContextFactory<AppDBContext>
    {
        public AppDBContext CreateDbContext(string[] args)
        {
            var optionsBuilder = new DbContextOptionsBuilder<AppDBContext>();

            optionsBuilder.UseMySql(
                "Server=localhost;Port=3307;Database=Merkadit;User Id=root;Password=5684;",
                new MySqlServerVersion(new Version(8, 0, 43)) // Versión correcta
            );

            return new AppDBContext(optionsBuilder.Options);
        }
    }
}