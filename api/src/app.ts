import { DocumentClient, GetItemOutput, ScanOutput, AttributeMap } from "aws-sdk/clients/dynamodb";
import { Request, SymbolItem, WordItem } from './index';
import { PromiseResult } from "aws-sdk/lib/request";
import { AWSError } from "aws-sdk/lib/error";

export const app = async (dbClient: DocumentClient, symbolItems: SymbolItem[], event: Request): Promise<any> => {
  let word: PromiseResult<GetItemOutput, AWSError>;
  const americaTable = process.env.AmericaTable as string;
  const englandTable = process.env.EnglandTable as string;

  // America
  if (event.lan && event.lan === '2') {
    word = await getWord(dbClient, americaTable, event.word);
  } else {
    word = await getWord(dbClient, englandTable, event.word);
  }
  // 存在しない場合、終了する
  if (!word.Item) return;

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

  console.log(result.join(''));

  return result.join('');
}

/**
 * 単語のIPA情報を取得する
 * 
 * @param tableName テーブル名
 * @param word 単語
 */
const getWord = async (dbClient: DocumentClient, tableName: string, word: string) => dbClient.get({
  TableName: tableName,
  Key: {
    'word': word.toUpperCase(),
  }
}).promise();
