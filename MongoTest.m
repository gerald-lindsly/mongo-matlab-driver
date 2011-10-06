MongoStart;
for x = 1:0
    disp(x);
end

ba = BsonBuffer;
ba.append('test', 'testing');
y = ba.finish;

i = y.iterator;
i.clear;

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

bb.startObject('sub');
bb.append('baz', int32(3));
bb.append('zip', 26);
bb.finishObject;
bb.append('more', 'much');

x = bb.finish;
display(x);

'where'
% bb.append('codewscope', BsonCodeWScope('code for scope', y)); %

i = BsonIterator(x);
while i.next
    t = i.type;
    if t == BsonType.OBJECT
        disp(i.key);
        j = BsonIterator(i);
        while j.next
            v = j.value;
            disp([j.key, ': (', class(v), ') ']);
            disp(v);
        end
    elseif t == BsonType.BINDATA
        v = i.value;
        disp([i.key, ': (', class(v), '), ']);
        disp(i.binaryType);
        disp(v);
    elseif t == BsonType.DATE
        v = i.value;
        disp([i.key, ': (', class(v), '), ']);
        disp(datestr(v));
    else
        v = i.value;
        disp([i.key, ': (', class(v), ') ']);
        disp(v);
    end
    display ([]);
end