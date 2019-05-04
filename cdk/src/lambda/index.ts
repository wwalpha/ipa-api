import { Callback } from 'aws-lambda';

export const handler = (event: any, _: any, callback: Callback) => {
  console.log(callback, event);
}