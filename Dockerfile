# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy the solution and project files
COPY ["DevOps.sln", "./"]
COPY ["Web/Web.csproj", "Web/"]
RUN dotnet restore "DevOps.sln"

# Copy the rest of the source code
COPY . .

# Build and publish
RUN dotnet build "DevOps.sln" -c Release -o /app/build
RUN dotnet publish "DevOps.sln" -c Release -o /app/publish /p:UseAppHost=false

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

# Copy published files
COPY --from=build /app/publish .

# Configure environment
ENV ASPNETCORE_URLS=http://+:5000
ENV ASPNETCORE_ENVIRONMENT=Production

# Expose port
EXPOSE 5000

# Set entry point
ENTRYPOINT ["dotnet", "Web.dll"]