using Microsoft.EntityFrameworkCore;
using Merkadit.Models;

namespace Merkadit.Data
{
    public class AppDBContext : DbContext
    {
        public AppDBContext(DbContextOptions<AppDBContext> options) : base(options) { }

        public DbSet<UserAccounts> UserAccounts { get; set; }
        public DbSet<Roles> Roles { get; set; }
        public DbSet<UserRoles> UserRoles { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // UserAccounts
            modelBuilder.Entity<UserAccounts>(tb =>
            {
                tb.HasKey(col => col.Id);
                tb.Property(col => col.Id).UseIdentityColumn().ValueGeneratedOnAdd();

                tb.Property(col => col.username).HasMaxLength(100).IsRequired();
                tb.HasIndex(col => col.username).IsUnique();

                tb.Property(col => col.password_hash).HasMaxLength(255).IsRequired();
                tb.Property(col => col.email).HasMaxLength(190);
                tb.HasIndex(col => col.email).IsUnique();

                tb.Property(col => col.full_name).HasMaxLength(190);

                tb.Property(col => col.is_active)
                    .HasDefaultValue(true)
                    .IsRequired();

                tb.Property(col => col.created_at)
                    .HasColumnType("timestamp")
                    .HasDefaultValueSql("CURRENT_TIMESTAMP");

                tb.Property(col => col.updated_at)
                    .HasColumnType("timestamp")
                    .HasDefaultValueSql("CURRENT_TIMESTAMP")
                    .ValueGeneratedOnAddOrUpdate();
            });

            // Roles
            modelBuilder.Entity<Roles>(tb =>
            {
                tb.HasKey(col => col.Id);
                tb.Property(col => col.Id).UseIdentityColumn().ValueGeneratedOnAdd();

                tb.Property(col => col.name).HasMaxLength(100).IsRequired(); 
                tb.HasIndex(col => col.name).IsUnique();

                tb.Property(col => col.description).HasMaxLength(255);
            });

            // UserRoles (Many-to-Many)
            modelBuilder.Entity<UserRoles>(tb =>
            {
                tb.HasKey(ur => new { ur.user_id, ur.role_id });

                tb.HasOne(ur => ur.UserAccount)
                  .WithMany(u => u.UserRoles)
                  .HasForeignKey(ur => ur.user_id);

                tb.HasOne(ur => ur.Role)
                  .WithMany(r => r.UserRoles)
                  .HasForeignKey(ur => ur.role_id);
            });

            modelBuilder.Entity<UserAccounts>().ToTable("UserAccounts");
            modelBuilder.Entity<Roles>().ToTable("Roles");
            modelBuilder.Entity<UserRoles>().ToTable("UserRoles");
        }
    }
}
