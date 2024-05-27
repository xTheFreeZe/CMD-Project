module create_project

import os

fn print_in_color(color string, text string) {
  println('\u001b[1;' + color + 'm' + text + '\u001b[0m')
}

// Important: The project path has already been merged with the project name in the main.v file
pub fn create_project(project_name string, project_path string, project_language string, project_template bool) bool {
  if os.exists(project_path) {
    print_in_color('31', 'The project path already exists [Error Code 6]')
    return false
  }

  os.mkdir(project_path) or {
    print_in_color('31', 'Failed to create the project directory [Error Code 7]')
    println(os.last_error())
    return false
  }

  asset_path := os.join_path(os.getwd(), 'assets')

  if project_language.to_lower() == 'ts' || project_language.to_lower() == 'typescript' {
    if project_template {
      print_in_color('90', 'Created Dir, locating TS Template...')

      typescript_asset_path := os.join_path(asset_path, 'typescript')

      if !os.exists(typescript_asset_path) {
        print_in_color('31', 'The TypeScript template does not exist [Error Code 8]')
        return false
      }

      print_in_color('90', 'Copying TS Template...')

      // Copy the TypeScript template files to the project path with the overwrite flag set to true
      os.cp_all(typescript_asset_path, project_path, true) or {
        print_in_color('31', 'Failed to copy the TypeScript template files [Error Code 9]')
        println(os.last_error())
        return false
      }

      print_in_color('90', 'Validating copied files...')

      // Checking if we successfully copied the TypeScript template files
      if !os.exists(os.join_path(project_path, 'tsconfig.json')) {
        print_in_color('31', 'The TypeScript template files were not copied successfully [Error Code 11]')
        return false
      }
    } else {
      print_in_color('32', 'Created TypeScript project successfully - Path: ${project_path}')
    }
  } else if project_language.to_lower() == 'v' || project_language.to_lower() == 'vlang' {
    if project_template {
      print_in_color('90', 'Created Dir, locating V Template...')

      v_asset_path := os.join_path(asset_path, 'v')

      if !os.exists(v_asset_path) {
        print_in_color('31', 'The V template does not exist [Error Code 8]')
        println(os.last_error())
        return false
      }

      print_in_color('90', 'Copying V Template...')

      os.cp_all(v_asset_path, project_path, true) or {
        print_in_color('31', 'Failed to copy the V template files [Error Code 9]')
        println(os.last_error())
        return false
      }

      print_in_color('90', 'Validating copied files...')

      if !os.exists(os.join_path(project_path, 'main.v')) {
        print_in_color('31', 'The V template files were not copied successfully [Error Code 11]')
        return false
      }
    } else {
      print_in_color('32', 'Created V project successfully - Path: ${project_path}')
    }
  } else if project_language.to_lower() == 'js' || project_language.to_lower() == 'javascript' {
    if project_template {
      print_in_color('90', 'Created Dir, locating JS Template...')

      javascript_asset_path := os.join_path(asset_path, 'javascript')

      if !os.exists(javascript_asset_path) {
        print_in_color('31', 'The JavaScript template does not exist [Error Code 8]')
        return false
      }

      print_in_color('90', 'Copying JS Template...')

      os.cp_all(javascript_asset_path, project_path, true) or {
        print_in_color('31', 'Failed to copy the JavaScript template files [Error Code 9]')
        println(os.last_error())
        return false
      }

      print_in_color('90', 'Validating copied files...')

      if !os.exists(os.join_path(project_path, 'index.js')) {
        print_in_color('31', 'The JavaScript template files were not copied successfully [Error Code 11]')
        return false
      }
    } else {
      print_in_color('32', 'Created JavaScript project successfully - Path: ${project_path}')
    }
  } else {
    print_in_color('31', 'Invalid language selected [Error Code 10]')
    return false
  }
  return true
}
