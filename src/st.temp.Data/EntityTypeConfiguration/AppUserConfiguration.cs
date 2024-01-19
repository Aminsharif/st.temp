namespace st.temp.Data.EntityTypeConfiguration;

using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

public class AppUserConfiguration : IEntityTypeConfiguration<AppUser>
{
  public void Configure(EntityTypeBuilder<AppUser> builder)
  {
    if (builder == null)
    {
      throw new ArgumentNullException(nameof(builder));
    }

    builder.ToTable("AppUsers").HasKey(c => c.Id);

    builder.Property(m => m.Id).ValueGeneratedOnAdd();

    builder.Property(m => m.Created).ValueGeneratedOnAddOrUpdate();
  }
}
