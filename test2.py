import yaml
from jinja2 import Template, Environment, FileSystemLoader

def load_data(file_path):
    """Load YAML data from a file."""
    with open(file_path, 'r') as file:
        return yaml.safe_load(file)

def get_item_keys_and_values(data):
    """Extract and return ordered item keys and values."""
    item_keys = []
    item_values = []

    for item in data['spec']:
        # Collect unique keys in the order they appear
        for key in item.keys():
            if key not in item_keys:
                item_keys.append(key)
        item_values.append(item)

    return item_keys, item_values

def render_template(template_name, context, template_dir='templates'):
    """Render a Jinja2 template with the given context."""
    env = Environment(loader=FileSystemLoader(template_dir))
    template = env.get_template(template_name)
    return template.render(context)

def generate_variable_file(data_file='data.yml', 
                           variables_template='variable.tf.j2',
                           tfvars_template='terraform.tfvars.j2',
                           variables_output='variables.tf',
                           tfvars_output='terraform.tfvars',
                           main_template='main.tf.j2',
                           main_output='main.tf'):
    """Generate Terraform configuration and variables files from YAML data."""
    data = load_data(data_file)
    item_keys, item_values = get_item_keys_and_values(data)

    # Prepare context for templates
    var_context = {'item_keys': item_keys}
    tfvars_context = {'item_values': item_values}

    # Render templates
    variables_tf = render_template(variables_template, var_context)
    tfvars = render_template(tfvars_template, tfvars_context)
    main_tf = render_template(main_template, var_context)

    # Write rendered output to files
    with open(variables_output, 'w') as var_output_file, open(tfvars_output, 'w') as tfvars_output_file, open(main_output, 'w') as main_output_file:
        var_output_file.write(variables_tf)
        tfvars_output_file.write(tfvars)
        main_output_file.write(main_tf)

    print("The config files variables.tf and data.tfvars have been generated successfully!")

if __name__ == '__main__':
    generate_variable_file()