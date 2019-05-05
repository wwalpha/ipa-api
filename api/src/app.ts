import { DynamoDB, AWSError, Lambda } from "aws-sdk";
import { SymbolItem, WordItem, QueryParams, Result } from './index';
import { PromiseResult } from "aws-sdk/lib/request";
import { APIGatewayEvent } from "aws-lambda";

let dbClient: DynamoDB.DocumentClient;
let symbolItems: SymbolItem[];

export const app = async (event: APIGatewayEvent): Promise<Result> => {
  if (!event.queryStringParameters) {
    return undefined as unknown as Result;
  }

  let word: PromiseResult<DynamoDB.GetItemOutput, AWSError>;
  const americaTable = process.env.AmericaTable as string;
  const englandTable = process.env.EnglandTable as string;

  const params = event.queryStringParameters as unknown as QueryParams;

  // 初期化
  await init();

  // America
  if (params.lan && params.lan === '2') {
    word = await getWord(dbClient, americaTable, params.word);
  } else {
    word = await getWord(dbClient, englandTable, params.word);
  }

  // 存在しない場合、終了する
  if (!word.Item) {
    return {
      word: params.word,
      pronounce: undefined,
    }
  }

  // 単語のIPA情報
  const item = word.Item as unknown as WordItem;
  const ipas = item.ipa.split(' ');

  const result: string[] = [];

  ipas.forEach((item) => {
    const target = symbolItems.find(subItem => subItem.id === item);

    if (!target) return;

    // XX1
    if (target.id.length === 3 && target.id.charAt(2) === '1') {
      result.splice(result.length - 1, 0, 'ˈ');
    } else if (target.id.length === 3 && target.id.charAt(2) === '2') {
      // XX2
      result.splice(result.length - 1, 0, 'ˌ');
    }

    // XX0など
    result.push(target.ipa);
  })

  return {
    word: params.word,
    pronounce: result.join(''),
  }
}

/**
 * 単語のIPA情報を取得する
 * 
 * @param tableName テーブル名
 * @param word 単語
 */
const getWord = async (dbClient: DynamoDB.DocumentClient, tableName: string, word: string) => dbClient.get({
  TableName: tableName,
  Key: {
    'word': word.toUpperCase(),
  }
}).promise();


/**
 * 初期化
 */
const init = async () => {
  if (!dbClient) {
    dbClient = new DynamoDB.DocumentClient({
      region: process.env.AWS_DEFAULT_REGION,
    });

    // Symbols情報を取得する
    const result = await dbClient.scan({
      TableName: process.env.SymbolTable as string,
    }).promise();

    symbolItems = result.Items as unknown as SymbolItem[];
  }
}