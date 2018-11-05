import argparse
import os
import sys
import yaml
import re


def replace_values(yaml_file, value_file):
    def _get(dict, list):
        return reduce(lambda d, k: d[k], list, dict)

    def _replace(obj):
        if isinstance(obj, list):
            for item in obj:
                _replace(item)
        elif isinstance(obj, dict):
            for k, v in obj.iteritems():
                if isinstance(v, dict) or isinstance(v, list):
                    _replace(v)
                if isinstance(v, str):
                    match = re.match(r'^%(.*)%$', v)
                    if match:
                        reference = match.group(1).split('.')
                        replace = _get(value_file, reference)
                        obj[k] = replace
    _replace(yaml_file)
    return yaml_file

def parse_opts(argv):

    parser = argparse.ArgumentParser(
        description='Generate the config.json to suit the NIC Partitioning usecases')

    parser.add_argument('-v', '--value-file', metavar='VALUE_FILE',
                        help="""user values""", required=True)
    parser.add_argument('-s', '--sample-file', metavar='SAMPLE_FILE',
                        help="""path to the sample configuration file.""",
                        default='config_sample.yaml')
    parser.add_argument('-o', '--out-file', metavar='OUT_FILE',
                        help="""generated config file.""",
                        default='config.yaml')

    opts = parser.parse_args(argv[1:])

    return opts

def main(argv=sys.argv):
    opts = parse_opts(argv)
    with open(opts.sample_file, 'r') as sample_file:
        sample = yaml.load(sample_file)
    with open(opts.value_file, 'r') as value_file:
        value = yaml.load(value_file)
    output = replace_values(sample, value)

    with open(opts.out_file, 'w') as out:
        yaml.dump(output, out, default_flow_style=False)

if __name__ == '__main__':
    sys.exit(main(sys.argv))
