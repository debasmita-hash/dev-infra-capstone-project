# Project 20 - Deploy a Load-Balanced App

## Deploy

```bash
mkdir -p ~/capstone-projects/p20-load-balanced-app
cd ~/capstone-projects/p20-load-balanced-app
# Copy/extract the supplied files here.
cp terraform.tfvars.example terraform.tfvars
terraform fmt -recursive
terraform init
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

## Verify

```bash
ALB_DNS=$(terraform output -raw alb_dns_name)
TG_ARN=$(terraform output -raw target_group_arn)

echo "http://$ALB_DNS"
aws elbv2 describe-target-health \
  --region ap-south-1 \
  --target-group-arn "$TG_ARN" \
  --query 'TargetHealthDescriptions[].{Instance:Target.Id,Port:Target.Port,State:TargetHealth.State}' \
  --output table

for i in $(seq 1 12); do
  curl -s "http://$ALB_DNS/?request=$i" | grep -E 'Web Server|Instance ID|Availability Zone'
  sleep 1
done
```

Both targets must show `healthy`. The curl results should contain responses from both Web Server 1 and Web Server 2.

## Screenshot

Open the `application_url` output in a browser. Capture one browser window containing two side-by-side tabs or browser windows, one showing **Web Server 1** and one showing **Web Server 2**. If refresh does not change the server immediately, hard-refresh or add a changing query string, such as `?request=1`, `?request=2`, and so on.

For stronger evidence, include the AWS console target group **Targets** tab showing both instances as **Healthy** in the screenshot.

## Destroy

```bash
terraform destroy -auto-approve
```
