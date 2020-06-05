import objects as o

def flatten_filtered(d, gk):
    
    def flatten(d):
        out = {}
        for key, val in d.items():
            if isinstance(val, dict):
                val = [val]
            if isinstance(val, list):
                for subdict in val:
                    deeper = flatten(subdict).items()
                    out.update({key + '/' + key2: val2 for key2, val2 in deeper})
            else:
                out[key] = val 
        return out
        
    def filtered(fd, gk):
        filtered = flatten(fd).get(gk)

        return filtered

    return filtered(flatten(d), gk)

if __name__ == '__main__':

    # Given key (gk) examples: obj1(a/b/c), obj2(b/b/c), obj3(USA/Texas/Austin/2017-01-01)
    example1 = flatten_filtered(o.obj1, 'a/b/c')
    example2 = flatten_filtered(o.obj2, 'b/b/c')
    example3 = flatten_filtered(o.obj3, 'USA/Texas/Austin/2017-01-01')

    print(example1)
    print(example2)
    print(example3)
    print(':)')