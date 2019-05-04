import { Stack, Construct, StackProps } from '@aws-cdk/cdk';
import { RestApi, LambdaIntegration } from '@aws-cdk/aws-apigateway'
import { Function, Runtime, Code } from '@aws-cdk/aws-lambda';

export class CdkStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    // The code that defines your stack goes here
    const backend = new Function(this, 'ipa-lambda', {
      functionName: 'ipa-converter',
      runtime: Runtime.NodeJS810,
      handler: 'index.handler',
      code: Code.asset('./dist/lambda'),
    });

    const api = new RestApi(this, 'ipa', {});
    api.root.addMethod('GET', new LambdaIntegration(backend));

  }
}
