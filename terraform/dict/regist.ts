import { BatchWriteItemOutput, BatchWriteItemInput, DocumentClient, Key } from 'aws-sdk/clients/dynamodb';
import * as fs from 'fs';

const db = new DocumentClient({
  region: 'ap-northeast-1',
});

// エラー表示
process.on('rejectionHandled', console.log);

const invokes: Promise<BatchWriteItemOutput>[] = [] as any;

const exec = async (items: Promise<BatchWriteItemOutput>[]) => {
  const result = await Promise.all(items);

  let hasUnprocessed = false;
  for (const idx in result) {
    const item = result[idx];

    // 未処理データ
    if (item.UnprocessedItems && Object.keys(item.UnprocessedItems).length > 0) {
      console.log(`UnprocessedItems: ${Object.keys(item.UnprocessedItems).length}`);

      hasUnprocessed = true;
    }
  }

  if (hasUnprocessed) {
    console.log('Wait 10 seconds....');
    await sleep();
  }

  for (const idx in result) {
    const item = result[idx];

    // 未処理データ
    if (item.UnprocessedItems && Object.keys(item.UnprocessedItems).length > 0) {
      let unprocessed = [] as any;
      let tableName: string = 'dummy';

      Object.keys(item.UnprocessedItems).forEach((key) => {
        tableName = key;

        if (item.UnprocessedItems) {
          unprocessed = item.UnprocessedItems[key];
        }
      });

      await db.batchWrite({
        RequestItems: {
          [tableName]: unprocessed,
        },
      }).promise();
    }
  }

  items.length = 0;
};

const sleep = () => new Promise(resolve => setTimeout(resolve, 10000));

export const regist = async (fileName: string, tableName: string, maxThread: number) => {
  console.log(`Start insert data to ${tableName}`);

  const lines: string[] = fs.readFileSync(fileName, 'utf-8').split('\n');
  const items: any = [];

  for (const idx in lines) {
    if (lines[idx].startsWith(';;;')) {
      continue;
    }

    if (invokes.length === maxThread) {
      await exec(invokes);

      console.log(`Finish: ${Number(idx) - 1}`);
    }

    if (Number(idx) % 25 === 0 && items.length > 0) {
      const params: BatchWriteItemInput = {
        RequestItems: {
          [tableName]: items,
        },
      };

      invokes.push(db.batchWrite(params).promise());

      // delete
      items.length = 0;
    }

    // space * 2
    const ipa = lines[idx].split('  ');

    console.log(ipa);
    items.push({
      PutRequest: {
        Item: {
          id: ipa[0],
          ipa: ipa[1],
        },
      },
    });
  }

  invokes.push(db.batchWrite({
    RequestItems: {
      [tableName]: items,
    },
  }).promise());

  await exec(invokes);

};

const scan = async (tableName: string, startKey?: Key): Promise<number> => {
  console.log('key', startKey);

  let sub = 0;

  const result = await db.scan({
    TableName: tableName,
    ExclusiveStartKey: startKey,
  }).promise();

  if (result.LastEvaluatedKey) {
    sub = await scan(tableName, result.LastEvaluatedKey);
  }

  if (result.Count) {
    return result.Count + sub;
  }

  return 0;
};


// regist('america.dict', 'ipa-america', 10);
// regist('england.dict', 'ipa-england', 10);
regist('cmudict.symbols', 'ipa-symbol', 10);