using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Devices.Models;

namespace Devices.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<RelayChannel> RelayChannels { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<RelayChannel>()
                 .Property(r => r.Id)
                 .ValueGeneratedNever();
        }
    }
}
