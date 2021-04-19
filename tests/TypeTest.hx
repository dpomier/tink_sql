package;

import Db;

using tink.CoreApi;

@:asserts
@:allow(tink.unit)
class TypeTest extends TestWithDb {
	
	@:before
	public function createTable() {
		return db.Types.create();
	}
	
	@:after
	public function dropTable() {
		return db.Types.drop();
	}
	
	@:variant(new Date(2000, 0, 1, 0, 0, 0))
	@:variant(new Date(1920, 0, 1, 0, 0, 0))
	public function insert(mydate:Date) {
		var future = db.Types.insertOne({
			int: 123,
			float: 1.23,
			text: 'mytext',
			blob: haxe.io.Bytes.ofString('myblob'),
			varbinary: haxe.io.Bytes.ofString('myvarbinary'),
			date: mydate,
			boolTrue: true,
			boolFalse: false,
			
			nullInt: null,
			nullText: null,
			nullBlob: null,
			nullVarbinary: null,
			nullDate: null,
			nullBool: null,
		})
			.next(function(id:Int) return db.Types.first())
			.next(function(row:Types) {
				asserts.assert(row.int == 123);
				asserts.assert(row.text == 'mytext');
				asserts.assert(row.date.getTime() == mydate.getTime());
				asserts.assert(row.blob.toHex() == '6d79626c6f62');
				asserts.assert(row.varbinary.toHex() == haxe.io.Bytes.ofString('myvarbinary').toHex());
				asserts.assert(row.boolTrue == true);
				asserts.assert(row.boolFalse == false);
				
				asserts.assert(row.optionalInt == null);
				asserts.assert(row.optionalText == null);
				asserts.assert(row.optionalDate == null);
				asserts.assert(row.optionalBlob == null);
				asserts.assert(row.optionalVarbinary == null);
				asserts.assert(row.optionalBool == null);
				
				asserts.assert(row.nullInt == null);
				asserts.assert(row.nullText == null);
				asserts.assert(row.nullDate == null);
				asserts.assert(row.nullBlob == null);
				asserts.assert(row.nullVarbinary == null);
				asserts.assert(row.nullBool == null);
				
				return Noise;
			});
			
		future.handle(function(o) switch o {
			case Success(_): asserts.done();
			case Failure(e): asserts.fail(e);
		});
		
		return asserts;
	}
}