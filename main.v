module main

import os { exists, getwd, input, is_dir, join_path }
import create_project

fn print_in_color(color string, text string) {
	println('\u001b[1;' + color + 'm' + text + '\u001b[0m')
}

fn main() {
	print_in_color('32', 'Marwins Project Setup :)') // Green color
	println('You can choose from the following languages: \n')

	print_in_color('34', 'TypeScript [TS]') // Blue color
	print_in_color('33', 'JavaScript [JS]') // Yellow color
	print_in_color('36', 'The V Language [V]') // Cyan color
	valid_project_strings := ['ts', 'js', 'v', 'typescript', 'javascript', 'vlang']
	project_language := input("\u001b[1mPlease enter the programming language you'd like to use: \u001b[0m")

	if project_language == '' {
		print_in_color('31', '\nYou must choose a language to continue [Error Code 1]')
		return
	}

	if project_language.to_lower() !in valid_project_strings {
		print_in_color('31', '\nYou must choose a valid language to continue [Error Code 2]')
		return
	}

	project_name := input('\u001b[1mPlease enter the name of the project: \u001b[0m')

	if project_name == '' {
		print_in_color('31', '\nYou must enter a project name to continue [Error Code 3]')
		return
	}

	mut project_path := input("\u001b[1mPlease enter the path where you'd like to create the project (leave blank for current directory): \u001b[0m")

	if project_path == '' {
		project_path = join_path(getwd(), project_name)
	} else {
		if !exists(project_path.replace('"', '')) && !is_dir(project_path.replace('"', '')) {
			print_in_color('31', '\nInvalid path provided [Error Code 4]')
			return
		}
		project_path = join_path(project_path.replace('"', ''), project_name)
	}

	template := input('\u001b[1mWould you like to use a template? [Y/N] (leave blank for true): \u001b[0m')
	mut user_does_want_template := true

	if template.to_lower() == 'n' {
		user_does_want_template = false
	}

	project := {
		'name':     project_name
		'path':     project_path
		'language': project_language
		'template': '${user_does_want_template}'
	}

	print_in_color('32', '\nProject Details: ${project}')
	okay_to_continue := input('Are these details correct? [Y/N] (Leave blank for Y): ')

	if okay_to_continue.to_lower() == 'n' {
		print_in_color('31', '\nUser aborted the project creation process')
		return
	}

	print_in_color('32', '\nCreating project...')
	project_response := create_project.create_project(project_name, project_path, project_language,
		user_does_want_template)

	if project_response {
		print_in_color('32', '\nProject created successfully!')
		input('Press any key to exit...')
	} else {
		print_in_color('31', '\nProject creation failed')
	}
}
