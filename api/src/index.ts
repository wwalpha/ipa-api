import { app } from './app';

// イベント入口
export const handler = (event: Request, _: any, callback: Callback<Response>) => {
  // イベントログ
  console.log(event);

  app(event)
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

export type Callback<TResult = any> = (error?: Error | null | string, result?: TResult) => void;

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

