+++
date = "2016-11-07T21:48:23+11:00"
description = "Build an e-mail forwarder using AWS Lambda and SES"
categories = ["serverless"]
keywords = ["serverless","aws","SES","Lambda","Email"]
title = "Serverless E-mail Forwarder using Lambda"
+++

![Architecture Diagram](/images/ses-forwarder-architecture.png)

By now I'm sure you're sick of hearing about serverless this and serverless that. Well, here's some more.

I recently came across a nifty GitHub project to use AWS Lambda to forward e-mails for a domain to a single email address [(arithmetric/aws-lambda-ses-forwarder)](https://github.com/arithmetric/aws-lambda-ses-forwarder).

I've had an old domain lying around that I didn't use for email, so I thought I'd set it up and see how it went, I've written up some instructions below:

## Setup Lambda Function

* Log in to the [AWS Console](https://console.aws.amazon.com) 

* Select Lambda from the Console

* Create a "Blank Function"

* Don't worry about configuring a trigger (we'll do this later)

* Name your function "SesForwarder" and set the runtime to Node.js 4.3

* Copy the [index.js](https://github.com/arithmetric/aws-lambda-ses-forwarder/blob/master/index.js) from [arithmetric/aws-lambda-ses-forwarder](https://github.com/arithmetric/aws-lambda-ses-forwarder) to your function

* You'll want to configure the `defaultConfig` variable, ensure `fromEmail` is a SES Verified Email ([Verifying Email Addresses in Amazon SES)](https://docs.aws.amazon.com/ses/latest/DeveloperGuide/verify-email-addresses.html).

My config looks a little bit like this:

```javascript
var defaultConfig = {
  fromEmail: "noreply@mail.skunkw0rks.io",
  subjectPrefix: "",
  emailBucket: "bucket_name",
  emailKeyPrefix: "incoming/",
  forwardMapping: {
    "@skunkw0rks.io": [
      "different_email@example.com"
    ]
  }
};
```
It'll forward all emails from `@skunkworks.io` to the super legit `different_email@example.com`.

* You'll need to give it an IAM Role to give access to SES and to log output - here's an example:

```javascript
{
  "Version": "2012-10-17",
  "Statement": [
     {
        "Effect": "Allow",
        "Action": [
           "logs:CreateLogGroup",
           "logs:CreateLogStream",
           "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*"
     },
     {
        "Effect": "Allow",
        "Action": "ses:SendRawEmail",
        "Resource": "*"
     },
     {
        "Effect": "Allow",
        "Action": [
           "s3:GetObject",
           "s3:PutObject"
        ],
        "Resource": "arn:aws:s3:::bucket_name/*"
     }
  ]
}
```

## Configure SES

* If you haven't already, you'll need to verify the the email address you'll be sending from (and also the email you'll be forwarding to if you're in the Sandbox) (See: [Verifying Email Addresses in Amazon SES](https://docs.aws.amazon.com/ses/latest/DeveloperGuide/verify-email-addresses.html))

* Head over to the SES product page in the Console and click on Rule Sets on the left, you'll need to create a new Ruleset (or edit the existing one)

* Set the recipient to your domain
 * Select S3 as the action

* Choose the S3 bucket you created before
 * As well as the Prefix

* Select Lambda as another action
 * Select "SESForwarder" as the Lambda function
 * Keep the Invocation type as Event

## Configure S3

* If you're not already done it, be sure to create your S3 bucket (including the folder/prefix you've defined in the Lambda Config)

* Make sure SES can write to your S3 bucket with a policy like the following:

```javascript
{
  "Version": "2012-10-17",
  "Statement": [
     {
        "Sid": "GiveSESPermissionToWriteEmail",
        "Effect": "Allow",
        "Principal": {
           "Service": "ses.amazonaws.com"
        },
        "Action": "s3:PutObject",
        "Resource": "arn:aws:s3:::S3-BUCKET-NAME/*",
        "Condition": {
           "StringEquals": {
              "aws:Referer": "AWS-ACCOUNT-ID"
           }
        }
     }
  ]
}
```

## Testing

This should be everything you need to get up and running, send a test email to the domain and check for Invocation Errors in Lambda.


