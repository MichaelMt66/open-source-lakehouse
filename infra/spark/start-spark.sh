#start-spark.sh
#!/bin/bash
. "/opt/spark/bin/load-spark-env.sh"
# When the spark work_load is master run class org.apache.spark.deploy.master.Master
if [ "$SPARK_WORKLOAD" == "master" ];
then

export SPARK_MASTER_HOST=`hostname`

cd /opt/spark/bin && ./spark-class org.apache.spark.deploy.master.Master --ip $SPARK_MASTER_HOST --port $SPARK_MASTER_PORT --webui-port $SPARK_MASTER_WEBUI_PORT >> $SPARK_MASTER_LOG

elif [ "$SPARK_WORKLOAD" == "worker" ];
then
# When the spark work_load is worker run class org.apache.spark.deploy.master.Worker
cd /opt/spark/bin && ./spark-class org.apache.spark.deploy.worker.Worker --webui-port $SPARK_WORKER_WEBUI_PORT $SPARK_MASTER >> $SPARK_WORKER_LOG

elif [ "$SPARK_WORKLOAD" == "thift" ];
then
    echo "SPARK SUBMIT"
    
cd /spark-app && 

/opt/spark/bin/spark-submit --master spark://spark-master:7077 --total-executor-cores $SPARK_WORKER_CORES --driver-memory $SPARK_DRIVER_MEMORY --executor-memory $SPARK_EXECUTOR_MEMORY \
--jars hadoop-aws-3.2.0.jar,aws-java-sdk-bundle-1.11.375.jar,hudi-spark3.1-bundle_2.12-0.12.2.jar \
--conf spark.executor.extraJavaOptions=-Duser.timezone=Etc/UTC --conf spark.eventLog.enabled=false  \
--conf spark.serializer=org.apache.spark.serializer.KryoSerializer \
--conf spark.sql.extensions=org.apache.spark.sql.hudi.HoodieSparkSessionExtension \
--conf spark.sql.warehouse.dir=s3a://$HUDI_S3_BUCKET/data/dbt \
--conf spark.hadoop.hive.metastore.uris=thrift://hive-metastore:9083 \
--conf spark.hadoop.fs.s3a.impl=org.apache.hadoop.fs.s3a.S3AFileSystem \
--conf spark.hadoop.fs.s3a.aws.credentials.provider=org.apache.hadoop.fs.s3a.SimpleAWSCredentialsProvider \
--conf spark.hadoop.fs.s3a.access.key=$AWS_ACCESS_KEY_ID --conf spark.hadoop.fs.s3a.secret.key=$AWS_SECRET_ACCESS_KEY \
--conf spark.hive.metastore.schema.verification=false \
--conf spark.driver.userClassPathFirst=true \
--conf spark.datanucleus.schema.autoCreateAll=true \
--class org.apache.spark.sql.hive.thriftserver.HiveThriftServer2 --name "Thrift JDBC/ODBC Server" spark-internal

else

    echo "Undefined Workload Type $SPARK_WORKLOAD, must specify: master, worker, thift"
fi
