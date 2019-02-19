echo START of the Shell Script EXECUTION
echo $(date)
dotnet --version
# Prompt User to Enter Project Name
read -p "Please enter project name :" projectName
# Make Dir projectName
mkdir $projectName
# Get into the projectName Dir
cd $projectName
# Create A new blank Web API Project
dotnet new webapi
# Make changes to the proj file of wavemaker.csproj
cp ../master/master.csproj $projectName.csproj
# Call .Net Restore to update the Proj references.
dotnet restore
#  EF Core Scafolding
dotnet ef dbcontext scaffold "Server=192.168.3.60;Database=Employee;User Id=SA;Password=Pramati@098" Microsoft.EntityFrameworkCore.SqlServer -o Models --context-dir context
# Remove Default created DB Context File
rm -rf context
# Copy the T4 template file into the wavemaker project
cp ../master/One.tt One.tt
# Execute the T4 template file
dotnet tt One.tt
# Copy Docker file into the current project folder from master template
cp ../master/Dockerfile Dockerfile
# Build Docker Image
docker build -t "${projectName}api" .
# Run Docker Container
docker run -d -p 8081:80 --name ${projectName}container --entrypoint "dotnet" ${projectName}api:latest ${projectName}.dll
echo END of the Shell Script EXECUTIONecho $(date)

