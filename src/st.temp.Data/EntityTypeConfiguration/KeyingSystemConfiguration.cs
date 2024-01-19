namespace st.temp.Data.EntityTypeConfiguration;

using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

public class KeyingSystemConfiguration : IEntityTypeConfiguration<KeyingSystem>
{
  public void Configure(EntityTypeBuilder<KeyingSystem> builder)
  {
    if (builder == null)
    {
      throw new ArgumentNullException(nameof(builder));
    }

    builder.ToTable("KeyingSystems").HasKey(c => c.Id);

    builder.Property(m => m.Id).ValueGeneratedOnAdd();

    builder.Property(m => m.Created).ValueGeneratedOnAddOrUpdate();
  }
}
