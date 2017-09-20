#cloud-config

hostname: ${hostname}
fqdn: ${hostname}.${domain}
manage_etc_hosts: true

runcmd:
  - curl -s http://api.fixer.io/latest?symbols=EUR,USD > /tmp/day-exchange.txt
  - curl -s http://api.fixer.io/`date +%Y-%m-%d`?symbols=EUR,USD > /tmp/exchange`date +%Y-%m-%d`.txt
  - sudo apt-get update
  - sudo apt-get install -y python python-pip
  - sudo pip install --upgrade pip
  - sudo pip install awscli
  - aws s3 cp /tmp/exchange`date +%Y-%m-%d`.txt s3://${bucket_name}
  - aws lambda invoke --function-name ${lambda_function_name} --region ${region} outputfile.txt
