MongoStart;

x = [1,2,3; 4,5,6]
size(x)
bc = BsonBuffer;
bc.append('mat2x3', x);
z = bc.finish()
i = z.iterator;
v = i.value

y = [.5, 1, 2; 0.6, 1.1, 2.1]
c = complex(x, y);
bc = BsonBuffer;
bc.append('cmat2x3', c);
z = bc.finish()
i = z.iterator;
v = i.value


B = cat(3, [1 2 3; 4 5 6], [7 8 9; 10 11 12])
bc = BsonBuffer;
bc.append('mat2x3x2', B);
z = bc.finish()

i = z.iterator;
q = i.value


bc = BsonBuffer;
bc.append('smat2x3x2', single(B));
z = bc.finish()
i = z.iterator;
q = i.value

bc = BsonBuffer;
bc.append('lmat2x3x2', int32(B));
z = bc.finish()
i = z.iterator;
q = i.value
class(q)

x = magic(4) >= 9
bc = BsonBuffer;
bc.append('lmat4x4', x);
z = bc.finish()
i = z.iterator;
q = i.value


ba = BsonBuffer;
ba.append('test', 'testing');
y = ba.finish;
y.display();

bb = BsonBuffer;
bb.append('foo', 5);
bb.append('boo', 'buzz');
bb.append('bar', int64(2));
bb.appendBinary('bin', uint8(eye(5)), 1);
oid = BsonOID;
disp(oid.toString());
bb.append('oid', oid);
bb.append('true', true');
bb.appendDate('date', now);
bb.append('null', []);
bb.append('regex', BsonRegex('pattern', 'options'));
bb.appendCode('code', '{ this = is + code; }');
bb.appendSymbol('symbol', 'symbol');
bb.append('codewscope', BsonCodeWScope('code for scope', y));

bb.startObject('sub');
bb.append('baz', int32(3));
bb.append('zip', 26);
bb.finishObject;
bb.append('more', 'much');

w = bb.finish;
display(w);
