#!/bin/bash

ARRAY=( 
    "customer;id;updated_at"
    "employee_privileges;employee_id,privilege_id;updated_at"
    "employees;id;updated_at"
    "inventory_transaction_types;id;updated_at"
    "inventory_transactions;id;updated_at"
    "invoices;id;updated_at"
    "order_details_status;id;updated_at"
    "order_details;id;updated_at"
    "orders_status;id;updated_at"
    "orders_tax_status;id;updated_at"
    "orders;id;updated_at"
    "privileges;id;updated_at"
    "products;id;updated_at"
    "purchase_order_details;id;updated_at"
    "purchase_order_status;id;updated_at"
    "purchase_orders;id;updated_at"
    "shippers;id;updated_at"
    "suppliers;id;updated_at"
    
)


for table in "${ARRAY[@]}"
do
    # turn e.g. 'domain.de;de;https' into
    # array ['domain.de', 'de', 'https']
    IFS=";" read -r -a arr <<< "${table}"

    TABLE="${arr[0]}"
    PRIMARY_KEY="${arr[1]}"
    PRE_COMBINE="${arr[2]}"
    DATABASE="transactional"
    echo "TABLE : ${TABLE}"
    echo "PRIMARY_KEY : ${PRIMARY_KEY}"
    echo "PRE_COMBINE : ${PRE_COMBINE}"

    /opt/spark/bin/spark-submit \
    --master spark://spark-master:7077 \
    --driver-memory 1G \
    --executor-memory 1G \
    --conf spark.hadoop.fs.s3.impl=org.apache.hadoop.fs.s3a.S3AFileSystem \
    --conf spark.hadoop.fs.s3a.aws.credentials.provider=org.apache.hadoop.fs.s3a.SimpleAWSCredentialsProvider \
    --conf spark.hadoop.fs.s3a.access.key=$AWS_ACCESS_KEY_ID --conf spark.hadoop.fs.s3a.secret.key=$AWS_SECRET_ACCESS_KEY \
    --conf spark.hadoop.fs.s3a.buffer.dir=/tmp/spark-data-tmp \
    --conf spark.hadoop.fs.s3a.fast.upload.buffer=bytebuffer \
    --conf spark.hive.metastore.uris=thrift://hive-metastore:9083 \
    --jars postgresql-42.5.4.jar,hadoop-aws-3.2.0.jar,aws-java-sdk-bundle-1.11.375.jar,hudi-spark3.1-bundle_2.12-0.12.2.jar,hudi-utilities-slim-bundle_2.12-0.12.2.jar,hudi-hive-sync-bundle-0.12.2.jar \
    --class org.apache.hudi.utilities.deltastreamer.HoodieDeltaStreamer hudi-utilities-slim-bundle_2.12-0.12.2.jar \
    --source-class org.apache.hudi.utilities.sources.JdbcSource \
    --target-base-path s3a://$HUDI_S3_BUCKET/data/${DATABASE}/${TABLE} \
    --target-table ${TABLE}  \
    --source-ordering-field ${PRE_COMBINE} \
    --table-type COPY_ON_WRITE \
    --hoodie-conf hoodie.deltastreamer.jdbc.url=jdbc:postgresql://postgres-database:5432/dev_database \
    --hoodie-conf hoodie.deltastreamer.jdbc.user=deuser \
    --hoodie-conf hoodie.deltastreamer.jdbc.password=depasswd \
    --hoodie-conf hoodie.deltastreamer.jdbc.driver.class=org.postgresql.Driver \
    --hoodie-conf hoodie.deltastreamer.jdbc.table.name=${DATABASE}.${TABLE}	\
    --hoodie-conf hoodie.deltastreamer.jdbc.incr.pull=TRUE \
    --hoodie-conf hoodie.deltastreamer.jdbc.table.incr.column.name=${PRE_COMBINE} \
    --hoodie-conf hoodie.datasource.write.keygenerator.class=org.apache.hudi.keygen.NonpartitionedKeyGenerator \
    --hoodie-conf hoodie.datasource.write.recordkey.field=${PRIMARY_KEY} \
    --enable-hive-sync \
    --hoodie-conf hoodie.datasource.hive_sync.partition_extractor_class=org.apache.hudi.hive.MultiPartKeysValueExtractor \
    --hoodie-conf hoodie.datasource.hive_sync.mode=hms \
    --hoodie-conf hoodie.datasource.write.hive_style_partitioning=true \
    --hoodie-conf hoodie.datasource.hive_sync.database=${DATABASE} \
    --hoodie-conf hoodie.datasource.hive_sync.table=${TABLE} \
    --op UPSERT
done
