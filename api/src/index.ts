import { Callback } from 'aws-lambda';
import { DocumentClient, ScanOutput } from 'aws-sdk/clients/dynamodb';
import { app } from './app';

let dbClient: DocumentClient;
let symbols: ScanOutput;

// イベント入口
export const handler = async (event: Request, _: any, callback: Callback<Response>) => {
  // イベントログ
  console.log(event);

  await init();

  // 初期化失敗
  if (!symbols.Items) {
    callback('初期化失敗しました', {} as Response);
  }

  app(dbClient, symbols.Items as unknown as SymbolItem[], event)
    .then((response: Response) => {
      // 終了ログ
      console.log(response);
      callback(null, response);
    })
    .catch((err) => {
      // エラーログ
      console.log(err);
      callback(err, {} as Response);
    });
};

export interface Response {
}

export interface Request {
  word: string
  lan?: string
}

export interface WordItem {
  word: string;
  ipa: string;
}

export interface SymbolItem {
  id: string;
  ipa: string;
}

/**
 * 初期化
 */
const init = async () => {
  if (!dbClient) {
    dbClient = new DocumentClient({
      region: process.env.AWS_DEFAULT_REGION,
    });

    // Symbols情報を取得する
    symbols = await dbClient.scan({
      TableName: process.env.SymbolTable as string,
    }).promise();
  }
}
