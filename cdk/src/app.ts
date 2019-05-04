import cdk = require('@aws-cdk/cdk');
import { CdkStack } from './stack';

const app = new cdk.App();
new CdkStack(app, 'ipa-api');
