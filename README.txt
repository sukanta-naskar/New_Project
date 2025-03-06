docker build -t patient-service -f Dockerfile.patient .
docker run -p 3000:3000 patient-service

http://127.0.0.1:3000/patients

docker build -t appointment-service -f Dockerfile.appointment .
docker run -p 3001:3001 appointment-service

http://127.0.0.1:3000/appointments


Push your code to GitHub and let the GitHub Actions workflow handle the Docker image build and push to Docker Hub

Create a project in github called AWS_PROJECT
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/sukanta-naskar/AWS_PROJECT.git
git push -u origin main

