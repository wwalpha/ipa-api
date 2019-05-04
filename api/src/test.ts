import { handler } from './index';

process.env['AmericaTable'] = 'ipa-america';
process.env['EnglandTable'] = 'ipa-england';
process.env['SymbolTable'] = 'ipa-symbol';

const callback = (error: any, value: any) => {
  console.log(error, value);
}

// handler({ word: 'america' }, undefined, callback);
// handler({ word: 'amenities' }, undefined, callback);
handler({ word: 'americanization', lan: '2' }, undefined, callback);

// əˈmɛrɪkə
// əˈmɛrɪkə

// AH0 M EH1 R IH0 K AH0

// AH0 M EH1 R AH0 K AH0
// AH0 M EH1 R IH0 K AH0