open Frei0r

let () =
  let fname = Sys.argv.(1) in
  let (v,v') = Frei0r.version () in
  Printf.printf "Using frei0r %d.%d\n\n%!" v v';
  let p = Frei0r.load fname in
  let info = Frei0r.info p in
  Printf.printf "%s %d.%d (by %s) for frei0r %d:\n%s.\n%!" info.name info.major_version info.minor_version info.author info.frei0r_version info.explanation;
  Printf.printf "\nPlugin type: %s.\n%!" (Frei0r.string_of_plugin_type info.plugin_type);
  Printf.printf "Color model: %s.\n%!" (Frei0r.string_of_color_model info.color_model);
  Printf.printf "\n%d parameters:\n%!" info.num_params;
  for i = 0 to info.num_params - 1 do
    let info = Frei0r.param_info p i in
    Printf.printf " - %s (%s): %s\n%!" info.param_name (Frei0r.string_of_param_type info.param_type) info.param_explanation;
  done;
  Printf.printf "\n";
  Gc.full_major ()
