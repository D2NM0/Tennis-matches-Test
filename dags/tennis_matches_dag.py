from airflow.decorators import dag, task
from airflow.providers.google.cloud.transfers.local_to_gcs import LocalFilesystemToGCSOperator
from airflow.providers.google.cloud.operators.gcs import GCSCreateBucketOperator
from airflow.providers.google.cloud.operators.bigquery import BigQueryCreateEmptyDatasetOperator
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator
from airflow.models.baseoperator import chain
from cosmos.airflow.task_group import DbtTaskGroup
from cosmos.constants import LoadMode
from cosmos.config import RenderConfig

from include.dbt.cosmos_config import DBT_PROJECT_CONFIG, DBT_CONFIG


@dag(schedule=None)
def airflow_pipeline():
    create_bucket = GCSCreateBucketOperator(
        task_id='create_bucket',
        bucket_name="modeo-technical-test-bucket",
        storage_class="MULTI_REGIONAL",
        location="EU",
        gcp_conn_id="gcp"
    )
    
    upload_csv_to_gcs = LocalFilesystemToGCSOperator(
        task_id = 'csv_to_gcs',
        src='/usr/local/airflow/include/Dataset.csv',
        dst='raw/Dataset.csv',
        bucket='modeo-technical-test-bucket',
        gcp_conn_id='gcp',
        mime_type='text/csv',

    )

    create_dataset = BigQueryCreateEmptyDatasetOperator(
        task_id='create_dataset',
        dataset_id='modeo_tt',
        gcp_conn_id='gcp'
    )

    load_csv = GCSToBigQueryOperator(
        task_id="gcs_to_bigquery",
        bucket="modeo-technical-test-bucket",
        source_objects=["raw/Dataset.csv"],
        destination_project_dataset_table=f"modeo_tt.raw_matches",
        write_disposition="WRITE_TRUNCATE",
        gcp_conn_id='gcp'
    )


    transform = DbtTaskGroup(
        group_id='transform',
        project_config=DBT_PROJECT_CONFIG,
        profile_config=DBT_CONFIG,
        render_config=RenderConfig(
            load_method=LoadMode.DBT_LS,
            select=['path:models/transform']
        )
    )
    
    chain(
        create_bucket,
        upload_csv_to_gcs,
        create_dataset,
        load_csv,
        transform,
    )

airflow_pipeline()