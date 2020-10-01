#!/usr/bin/env python3
# coding: utf-8




from jupyter_core import paths
from pathlib import Path
import sys
import argparse
import shlex, subprocess








def install_templates(template_path, user_path):
    user_path = Path(user_path).expanduser().absolute()
    for i in user_path.glob('*'):
        if i.is_dir():
            symlink_path = Path(template_path/i.name)
            try:
                symlink_path.symlink_to(i)
                print(f'added template {i}')
            except FileExistsError:
                print(f'skipping "{i.name}": a template with this name already exists')






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

    parser.add_argument('-f', '--input_file', help='notebook file to convert', default=None)
    parser.add_argument('-t', '--template', help=f'choose from a custom template stored in {template_path}', 
                        default=None)
    parser.add_argument('-o', '--output_dir', default=None)
    parser.add_argument('-l', '--list', action='store_true', 
                        help='list the available user-defined templates and exit', 
                        default=False)
    parser.add_argument('--to', default='python',
                        help="convert notebook to format [python*, html, latex, pdf, webpdf, slides, mardown, ascidoc, rst, script, notebook] *default")
    parser.add_argument('-i', '--install_templates', metavar='/path/to/custom_templates',
                        help=f'symlink templates from directory into {template_path} and exit', 
                        default=None)
    
    args, unknown_args = parser.parse_known_args()
    
    if len(unknown_args) > 0:
        print(f'unknown arguments: {unknown_args}')
        parser.print_help()
        return 1
    
        
    if args.list:
        list_template(template_path)
        return 0
    
    if args.install_templates:
        install_templates(template_path, Path(args.install_templates))
        return 0

    if args.input_file:
        input_file = Path(args.input_file).expanduser().absolute()
    else:
        parser.print_help()
        return 0
    
    
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
            print(f'template "{args.template}" does not exist')
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























