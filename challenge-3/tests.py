import unittest
import flatten
import objects as o

from ddt import ddt, data, unpack

@ddt
class TestType(unittest.TestCase):

    @data((o.obj1,'a/b/c'), (o.obj2,'b/b/c'), (o.obj3, 'USA/Texas/Austin/2017-01-01'))
    @unpack
    def test_not_null(self, first_value, second_value):
        #Map ddt args to more semantic var names
        d, gk = first_value, second_value

        #Pass args to func
        to_test = flatten.flatten_filtered(d, gk)

        #Run assertion test
        self.assertIsNotNone(to_test, "NoneType found. Either user error or function failed ro recurse.")

    @data((o.obj1,'a/b/c'), (o.obj2,'b/b/c'), (o.obj3, 'USA/Texas/Austin/2017-01-01'))
    @unpack
    def test_is_not_dict(self, first_value, second_value):

        d, gk = first_value, second_value

        to_test = flatten.flatten_filtered(d, gk)

        self.assertNotEqual(to_test, dict, "Output is a dictionary. Function has failed to recurse.")


if __name__ == '__main__':
    
    unittest.main(verbosity=2)