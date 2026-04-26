# Gunakan ASP.NET Runtime 8.0 (Sangat ringan, hanya ~200MB)
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

# Salin SEMUA file hasil publish dari folder host ke dalam kontainer
# Karena context build kita adalah folder Inventory_API, maka "." merujuk ke sana
COPY . .

# Set environment variabel agar aplikasi berjalan di port 80 (standar Docker)
ENV ASPNETCORE_URLS=http://+:80

# Ekspos port 80 agar bisa diakses oleh docker-compose
EXPOSE 80

# Jalankan DLL utama aplikasi kamu
# Pastikan nama file DLL sesuai dengan output publish kamu
ENTRYPOINT ["dotnet", "Inventory_API.dll"]