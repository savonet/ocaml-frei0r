exception Not_a_plugin
exception Failure

let () =
  Callback.register_exception "f0r_exn_not_a_plugin" Not_a_plugin;
  Callback.register_exception "f0r_exn_failure" Failure

external version : unit -> int * int = "ocaml_f0r_version"

type plugin

let default_paths = ["/usr/lib/frei0r-1"; "/usr/local/lib/frei0r-1"]

let default_paths =
  try ((Sys.getenv "HOME")^"/.frei0r-1/lib") :: default_paths
  with Not_found -> default_paths

external load : string -> plugin = "ocaml_f0r_dlopen"

type plugin_type =
| Filter
| Source
| Mixer2
| Mixer3

let string_of_plugin_type = function
  | Filter -> "filter"
  | Source -> "source"
  | Mixer2 -> "mixer2"
  | Mixer3 -> "mixer3"

type color_model =
| BGRA8888
| RGBA8888
| Packed32

let string_of_color_model = function
  | BGRA8888 -> "BGRA8888"
  | RGBA8888 -> "RGBA8888"
  | Packed32 -> "Packed32"

type info =
  {
    name : string;
    author : string;
    plugin_type : plugin_type;
    color_model : color_model;
    frei0r_version : int;
    major_version : int;
    minor_version : int;
    num_params : int;
    explanation : string;
  }

external info : plugin -> info = "ocaml_f0r_plugin_info"

type param_type =
| Bool
| Double
| Color
| Position
| String

let string_of_param_type = function
  | Bool -> "bool"
  | Double -> "double"
  | Color -> "color"
  | Position -> "position"
  | String -> "string"

type param_info =
  {
    param_name : string;
    param_type : param_type;
    param_explanation : string;
  }

external param_info : plugin -> int -> param_info = "ocaml_f0r_param_info"

type t

external create : plugin -> int -> int -> t = "ocaml_f0r_construct"

type color = float * float * float
type position = float * float

external get_param_bool : t -> int -> bool = "ocaml_f0r_get_param_bool"
external get_param_float : t -> int -> float = "ocaml_f0r_get_param_double"
external get_param_color : t -> int -> color = "ocaml_f0r_get_param_color"
external get_param_position : t -> int -> position = "ocaml_f0r_get_param_position"
external get_param_string : t -> int -> string = "ocaml_f0r_get_param_string"

external set_param_bool : t -> int -> bool -> unit = "ocaml_f0r_set_param_bool"
external set_param_float : t -> int -> float -> unit = "ocaml_f0r_set_param_double"
external set_param_color : t -> int -> color -> unit = "ocaml_f0r_set_param_color"
external set_param_position : t -> int -> position -> unit = "ocaml_f0r_set_param_position"
external set_param_string : t -> int -> string -> unit = "ocaml_f0r_set_param_string"

type data = (int, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t

external update : t -> float -> data option -> data -> unit = "ocaml_f0r_update"
let update0 i t = update i t None
let update1 i t d = update i t (Some d)
external update2 : t -> float -> data option -> data option -> data option -> data -> unit = "ocaml_f0r_update2_byte" "ocaml_f0r_update2"
let update3 i t d1 d2 d3 = update2 i t (Some d1) (Some d2) (Some d3)
let update2 i t d1 d2 = update2 i t (Some d1) (Some d2) None
