#!/usr/bin/env python3
# coding: utf-8




from jupyter_core import paths
from pathlib import Path
import sys
import argparse
import shlex, subprocess






def list_templates(template_path):
    print(f'\navailable user-defined templates in {template_path}:')
    for i in template_path.glob('*'):
        print(f'  * {i.name}')






def main():
    
    # run nbconvert using a custom template -- if the template isn't found, prompt to install
    # work around for no apparent way to specify custom paths to templates https://github.com/jupyter/nbconvert/issues/1428
    template_path = Path(paths.jupyter_data_dir())/'nbconvert/templates/'
    app_name = Path(sys.argv[0]).name
    
    
    help_epilog = f'''
    EXAMPLES:
    Basic conversion of notebook to python using a custom template
        $ {app_name} --template python_clean foo.ipynb
    
    Convert notebook to markdown
        $ {app_name} --to markdown bar.ipynb
    
    Convert notebook to python using a custom template and alternate output directory
        $ {app_name} --template python_clean --output_dir ./spam/ham monty.ipynb
    '''
    
    parser = argparse.ArgumentParser(description='convert jupyter notebooks using custom tempaltes',
                                    epilog=help_epilog,
                                    formatter_class=argparse.RawDescriptionHelpFormatter)

    parser.add_argument('input_file', help='notebook file to convert -- required')
    parser.add_argument('-t', '--template', help=f'choose from a custom template stored in {template_path}', 
                        default=None)
    parser.add_argument('-o', '--output_dir', default=None)
#     parser.add_argument('-l', '--list', action='store_true', 
#                         help='list the available user-defined templates', 
#                         default=False)
    parser.add_argument('--to', default='python',
                        help="convert notebook to format [python*, html, latex, pdf, webpdf, slides, mardown, ascidoc, rst, script, notebook] *default")
    
    args, unknown_args = parser.parse_known_args()
    
    if len(unknown_args) > 0:
        print(f'unknown arguments: {unknown_args}')
        parser.print_help()
        return 1
    
    input_file = Path(args.input_file).expanduser().absolute()
    if not input_file.exists():
        print(f'{input_file} not found')
        return 1
    
    if args.output_dir:
        output_dir = args.output_dir
    else:
        output_dir = input_file.parent
    
    try:
        template = template_path/args.template
    except TypeError:
        template = None
        
    if template:
        if not template.exists():
            print(f'template "{args.template}"" does not exist')
            print(f'try adding the template "{args.template}" to {template_path}')
            list_templates(template_path)

            return 1


    # build exec_string
    flags = ['jupyter-nbconvert', f'--to {args.to}']

    if template:
        flags.append(f'--template {template}')
    if output_dir:
        flags.append(f'--output-dir {output_dir}')
    
    flags.append(str(input_file))
    
    exec_string = " ".join(flags)
    
    print(exec_string)

    exec_args = shlex.split(exec_string)
    execute = subprocess.Popen(exec_args, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    print(execute.communicate()[0])
    print(execute.communicate()[1])
    return(execute.returncode)






if __name__ == "__main__":
    exit_code = main()
    if exit_code > 0:
        print('errors were encountered')
        exit(exit_code)






# sys.argv
# sys.argv = sys.argv[:-2]
# sys.argv.extend(['-h'])























