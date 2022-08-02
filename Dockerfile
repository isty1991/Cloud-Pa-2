FROM datamechanics/spark:3.1-latest

ENV PYSPARK_MAJOR_PYTHON_VERSION=3

WORKDIR /opt/wine-prediction
RUN conda install numpy

COPY /test.py .
ADD ValidationDataset.csv .
Add model ./model/
