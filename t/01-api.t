#!perl

use strict;

use Data::Dumper;

use Test::More tests => 6;

use lib qw(t/);

use TestClass;

# TestClass->db_Main->trace(2);

# run query and get info
my $results = [ [qw/foo_id foo_name foo_bar/],[20,'aaaa','bbbb',],[21,'aaaa','cccc',] ];
# warn Dumper(results => $results);


# diag "[debug] manual query to objects \n";
TestClass->next_result($results);
my $dbh = TestClass->db_Main;
my $sth = $dbh->prepare('select * from notam');
my $rv = $sth->execute();
my $objects = TestClass->sth_to_objects($sth);

isa_ok($objects,'Class::DBI::Iterator');

# diag "[debug] searching \n";

TestClass->next_result($results);
$objects = TestClass->search( foo_name=>'aaaa');

isa_ok($objects,'Class::DBI::Iterator');


#diag "[debug] getting first object \n";

my $object = $objects->next();

isa_ok($object,'TestClass');

#warn "[debug] got object : ",$object->id,"\n";

is($object->id,20);

$object->foo_bar('ffff');

#diag "[debug] updating object  \n";

TestClass->next_result([['foo_id'],]);
ok($object->update(), 'updated object ok');

#diag "[debug] creating TestClass  \n";

my $new_object = TestClass->create({foo_id => 99, foo_name => 'cccc', foo_bar => 'sdasd' });

isa_ok($new_object,'TestClass');
