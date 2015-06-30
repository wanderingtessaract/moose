[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 40
  xmax = 25
[]

[Variables]
  [./op]
  [../]
[]

[ICs]
  [./op_IC]
    type = SmoothCircleIC
    x1 = 0.0
    y1 = 0.0
    radius = 6.0
    invalue = 0.9
    outvalue = 0.1
    int_width = 3.0
    variable = op
  [../]
[]

[Kernels]
  [./op_dot]
    type = TimeDerivative
    variable = op
  [../]
  [./op_bulk]
    type = ACParsed
    variable = op
    f_name = F
    mob_name = L
  [../]
  [./op_interface]
    type = ACInterface
    variable = op
    kappa_name = 1
    mob_name = L
  [../]
[]

[Materials]
  [./consts]
    type = DerivativeParsedMaterial
    block = 0
    f_name  = L
    function = 'if(op<-1, 1, if(op>1, 1, 1 - 0.5*op^2))'
    args = 'op'
    outputs = exodus
    derivative_order = 1
  [../]
  [./free_energy]
    type = DerivativeParsedMaterial
    block = 0
    f_name = F
    args = 'op'
    function = '2*op^2*(1-op)^2 - 0.2*op'
    derivative_order = 2
  [../]
[]

[Executioner]
  type = Transient
  scheme = 'bdf2'

  solve_type = 'NEWTON'
  petsc_options_iname = 'pc_type'
  petsc_options_value = 'lu'

  l_max_its = 15
  l_tol = 1.0e-4

  nl_max_its = 15
  nl_rel_tol = 1.0e-9

  start_time = 0.0
  num_steps = 20
  dt = 2.0
[]

[Outputs]
  output_initial = true
  interval = 1
  exodus = true
  print_perf_log = true
[]
