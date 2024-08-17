import yaml
from jinja2 import Template

def load_data():
    with open('data.yml', 'r') as file:
        data = yaml.safe_load(file)
    return data

def generate_variable_file():
    data = load_data()

    # Collect keys and values separately
    item_keys = []
    item_values = []

    for item in data['spec']:
        # Add keys to item_keys in the order they appear
        for key in item.keys():
            if key not in item_keys:
                item_keys.append(key)
        # Collect all key-value pairs for item_values
        item_values.append(item)

    # Load jinja2 templates
    with open('variable.tf.j2', 'r') as var_template_file, open('data.tfvars.j2', 'r') as tfvars_template_file:
        var_template_content = var_template_file.read()
        tfvars_template_content = tfvars_template_file.read()

    # Render the templates with the YAML data
    variables_tf = Template(var_template_content).render(item_keys=item_keys)
    tfvars = Template(tfvars_template_content).render(item_values=item_values)

    # Write the rendered output to the respective files
    with open('variables.tf', 'w') as var_output_file, open('data.tfvars', 'w') as tfvars_output_file:
        var_output_file.write(variables_tf)
        tfvars_output_file.write(tfvars)

    print("The config files variables.tf and data.tfvars have been generated successfully!")

generate_variable_file()