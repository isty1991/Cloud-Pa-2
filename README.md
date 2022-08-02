## Docker-Wine-Prediction ##
Using Spark Cluster, Hadoop file system, docker and parallel implementation the python script will perform wine quality prediction 

# EC2 Instance Step up

1.Create one EC2 instance with either linux or Ubuntu AMI with t2.large image.

2.Now access your EC2 instance using Putty.

3.Configure your credentials using vi or nano .aws/credentials 

4. Copy the .pem file from your local machine to EC2-instance by using scp command

# Configure Flintrock

1. Install Python and pip on ec2 instance using the link
2. Now install Flintrock using

	pip install flintrock
3. use flintrock configure command. This will give you file location of config.yaml. So go to that location make changes in config file 
using vi or nano command.


change pem file and file location, use cluster type to t2.large.
make sure you intall both spark and hadoop by setting the value True.

4.For launching cluster use flintrock launch Cluster-name command.

5.Finally, login the cluster using flintrock login Cluster-name command. You are in your master node now.

Copy Data into the master Node of the cluster

To use SCP command we have to change the inbound rules for the master cluster

To do so click on the master node -> security -> security group of flintrock add ssh with 22 port and 0.0.0.0/0

now you can able to use scp command and copy tain.py, test.py ,TainingDataset.csv and ValidationDataset.csv

mkdir assignment

scp -i /Users/ishantyagi/Downloads/SparkMl.pem /Users/ishantyagi/Desktop/Cloud-Pa-2/TrainingDataset.csv ec2-user@ec2-54-90-98-17.compute-1.amazonaws.com:~/assignment/

# Parallel Training Implementation across cluster

1. Create a folder in hadoop file system to make datasets globally available for the nodes in the cluster. use

	hadoop fs -mkdir /data/
2. Copy files from master node to hdfs

    hdfs dfs -put /home/ec2-user/assignment/TrainingDataset.csv /data/
    
    hdfs dfs -put /home/ec2-user/assignment/ValidationDataset.csv /data/
    
    cd assignment
3. To verify the files use 

	hdfs dfs -ls /data
4. Run the following command to create model and parallel traing implementation across your cluster

	 spark-submit --master spark://ip-172-31-30-207.ec2.internal:7077 train.py hdfs:///data/TrainingDataset.csv hdfs:///model
here ip-172-31-30-207.ec2.internal is the master node address
5. Then we have to get our model using

	hdfs dfs -get /model

# Single Machine Wine Prediction

On the master node, use

spark-submit --master local[*] test.py file:///home/ec2-user/assignment/ValidationDataset.csv file:///home/ec2-user/assignment/model\
This will take only master node into consideration and we can see the Accuracy and F1-score on our local machine.

# Setting up Docker on Master node

1. Install most recent docker engine package: 

	sudo amazon-linux-extras install docker   or 
	sudo yum install docker
2. Start docker using

	sudo service docker start
3. Adding ec2-user to docker group

	sudo usermod -a -G docker ec2-user
4. Exit the flintrock cluster and login again.
5. verify ec2-user

	docker info
create docker hub account to see your image
6. Create "Dockerfile" in the assignment folder 
7. Build the docker image using

	"docker build -t winepred ."
8. Tag the docker image using

	docker tag winepred it55/wine-quality:tag
9. Login to the docker using

	docker login
10. Pushing the image to Docker hub repository

	docker push it55/wine-quality:tag
11. Pull the image from the Docker hub repository

	docker pull it55/wine-quality:tag

# Use Docker Container for wine Prediction

1. Launch your ec2-instance and then step-up docker using the above steps.

Go to https://hub.docker.com/r/it55/wine-quality for the docker repository

2. Pull the image to Docker hub repository

	docker pull it55/wine-quality:tag
3. Run the image using : 

docker run it55/wine-quality:tag driver test.py ValidationDataset.csv model
You will see Accuracy and F1-score

