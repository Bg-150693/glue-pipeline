"""
Run AWS Glue job and monitor execution
"""

import boto3zdsadsf
import time
import argparse
import sys
from config_loader import ConfigLoader

glue_client = boto3.client('glue')


def run_glue_job(job_name: str, job_arguments: dict = None) -> str:
    """
    Start a Glue job run.
    
    Args:
        job_name: Name of the Glue job
        job_arguments: Optional job arguments
        
    Returns:
        Job run ID
    """
    try:
        print(f"Starting Glue job: {job_name}")
        
        response = glue_client.start_job_run(
            JobName=job_name,
            Arguments=job_arguments or {}
        )
        
        job_run_id = response['JobRunId']
        print(f"✓ Job started successfully. Run ID: {job_run_id}")
        return job_run_id
    
    except Exception as e:
        print(f"✗ Failed to start job: {str(e)}")
        return None


def monitor_job_run(job_name: str, job_run_id: str, max_wait: int = 3600) -> bool:
    """
    Monitor Glue job execution.
    
    Args:
        job_name: Name of the Glue job
        job_run_id: Job run ID
        max_wait: Maximum wait time in seconds
        
    Returns:
        True if job succeeded
    """
    print(f"Monitoring job execution...")
    start_time = time.time()
    
    while True:
        elapsed = time.time() - start_time
        
        if elapsed > max_wait:
            print(f"✗ Job timeout after {max_wait} seconds")
            return False
        
        try:
            response = glue_client.get_job_run(
                JobName=job_name,
                RunId=job_run_id
            )
            
            job_run = response['JobRun']
            status = job_run['JobRunState']
            
            print(f"Status: {status} | Duration: {int(elapsed)}s")
            
            if status == 'SUCCEEDED':
                print("✓ Job completed successfully!")
                return True
            
            elif status == 'FAILED':
                error_msg = job_run.get('ErrorMessage', 'Unknown error')
                print(f"✗ Job failed: {error_msg}")
                return False
            
            elif status == 'STOPPED':
                print("✗ Job was stopped")
                return False
            
            # Wait before next check
            time.sleep(10)
        
        except Exception as e:
            print(f"✗ Error monitoring job: {str(e)}")
            return False


def main():
    """Main entry point"""
    parser = argparse.ArgumentParser(description='Run AWS Glue job')
    parser.add_argument('--environment', default='dev', help='Environment (dev, prod)')
    parser.add_argument('--wait', action='store_true', help='Wait for job completion')
    parser.add_argument('--timeout', type=int, default=3600, help='Max wait time in seconds')
    
    args = parser.parse_args()
    
    try:
        # Load configuration
        config_loader = ConfigLoader(env=args.environment)
        config = config_loader.load_config()
        
        job_name = config['glue']['job_name']
        
        # Start job
        job_run_id = run_glue_job(job_name)
        
        if not job_run_id:
            return 1
        
        # Monitor if requested
        if args.wait:
            if not monitor_job_run(job_name, job_run_id, args.timeout):
                return 1
        
        print("\n✓ Done!")
        return 0
    
    except Exception as e:
        print(f"✗ Error: {str(e)}")
        return 1


if __name__ == '__main__':
    sys.exit(main())
