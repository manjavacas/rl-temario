
#import "@preview/typslides:1.2.5": *

#show: typslides.with(
  ratio: "16-9",
  theme: "yelly",
)

#set text(lang: "es")
#set text(hyphenate: false)

#set figure(numbering: none)

#let colmath(x, color: red) = text(fill: color)[$#x$]

// *****************************************************************************

#front-slide(
  title: "Aprendizaje por refuerzo",
  subtitle: [Planificación],
  authors: "Antonio Manjavacas",
  info: "manjavacas@ugr.es",
)

// *****************************************************************************

#table-of-contents(title: "Contenidos")

// *****************************************************************************

#slide(title: [_Model-based_ _vs._ _Model-free_])[

  Hasta el momento hemos visto dos tipos de #stress[algoritmos de RL]...

]

// *****************************************************************************

#slide(title: [_Model-based_ _vs._ _Model-free_])[

  #framed(title: [_Model-based_])[
    - Requieren un *modelo* del entorno.
    - Se basan en la *planificación* a partir de ese modelo.
    - Ej. programación dinámica, búsqueda heurística.
  ]

]

// *****************************************************************************

#slide(title: [_Model-based_ _vs._ _Model-free_])[

  #framed(title: [_Model-free_])[
    - No necesitan un *modelo* del entorno.
    - Se basan en la capacidad de *aprendizaje*.
    - Ej. Monte Carlo, TD.
  ]

]

// *****************************************************************************

#slide(title: [_Model-based_ _vs._ _Model-free_])[

  A pesar de sus diferencias, tanto los métodos _model-based_ como los _model-free_ persiguen *un mismo objetivo*: el cálculo de las #stress[funciones de valor óptimas] ($v^*, q^*$) y, por tanto, de una #stress[política óptima] ($pi^*$).

  También comparten el mismo _modus operandi_:

  #framed[
    1. #stress[Mirar hacia delante], anticipando las consecuencias de posibles eventos futuros.
    2. Calcular un "#stress[valor de reserva]" (_backed-up_).
    3. Utilizar ese valor como herramienta (_target_, #stress[objetivo]) para aproximar $v$ o $q$.
  ]
]

// *****************************************************************************

#title-slide("Modelos y planificación")

// *****************************************************************************

#focus-slide[¿Qué es un _modelo_?]


// *****************************************************************************

#slide(title: [Modelo de un entorno])[

  #framed(
    title: [Modelo de entorno],
  )[Representación formal/abstracta del entorno que permite al agente #stress[predecir] las consecuencias de sus acciones. Esto es equivalente a *estimar transiciones*.]

  #align(center)[#image("images/model.png")]

]


// *****************************************************************************

#slide(title: [Tipos de modelos])[

  Si el entorno es #stress[estocástico], son posibles múltiples estados/recompensas siguientes, cada uno con diferente probabilidad.

  #framed[Algunos modelos ofrecen una descripción de todas las probabilidades de transición. Estos se denominan #stress[modelos de distribución] (_distribution models_).]

  #framed[Otros modelos solamente ofrecen como salida una de todas las posibles transiciones. Como esta transición se _muestrea_ en base a su probabilidad con respecto a todas las transiciones posibles, se denominan #stress[modelos muestrales] (_sample models_).]

]


// *****************************************************************************

#slide(title: [Tipos de modelos])[
  #align(center)[
    #box(height: 500pt)[
      #align(center)[#image("images/distrib-model.png")]
      #align(center)[#image("images/sample-model.png")]
    ]
  ]
]


// *****************************************************************************

#slide(title: [Tipos de modelos])[

  En *programación dinámica*, por ejemplo, se trabaja con #stress[modelos de distribución], ya que conocemos las dinámicas del MDP:

  #v(.3cm)

  #grayed[ $ p(s',r|s,a) $ ]

  #framed[Los modelos de distribución son más robustos que los muestrales, ya que pueden utilizarse igualmente para producir muestras.]

  #v(.2cm)

  No obstante, en la práctica es mucho más fácil obtener un modelo muestral.

]


// *****************************************************************************

#slide(title: [Tipos de modelos])[

  #framed[Un #stress[modelo muestral] puede emplearse para simular un episodio completo (de entre todos los posibles).]

  #framed[Un #stress[modelo de distribución] permite obtener todos los posibles episodios y sus probabilidades.

    - Facilitan la _evaluación de riesgos_ asociados a una determinada transición.
  ]

]


// *****************************************************************************

#slide(title: [Modelo de un entorno])[

  #framed[Los modelos permiten imitar/generar *experiencia*. Es decir, permiten #stress[simular] las dinámicas del entorno modelado y producir *experiencia simulada*.]

  - Permiten la toma de decisiones informada sin necesidad de interactuar con el entorno real.

  #emoji.bubble.thought La experiencia muestreada del modelo puede interpretarse como *_imaginar_* posibles escenarios que pueden ocurrir en el entorno real, y que dependen del entendimiento que se tiene del entorno.

]


// *****************************************************************************

#slide(title: [Ejemplo])[

  #align(center)[#image("images/plan-example.png")]

]


// *****************************************************************************

#focus-slide([Planificación])

// *****************************************************************************

#slide(title: [Planificación])[

  #framed(title: [Planificación])[
    Cualquier proceso computacional que toma un *modelo* como entrada y produce o mejora una #stress[política] que interactúa con el entorno modelado.
  ]

  #v(.5cm)

  #align(center)[#image("images/planning.png")]

  - _Definir una "estrategia" para actuar sobre el entorno modelado._
]


// *****************************************************************************

#slide(title: [Tipos de planificación])[

  #framed(title: [Planificación sobre el espacio de estados])[
    Búsqueda de una política óptima o camino óptimo hacia un objetivo a lo largo del #stress[espacio de estados].

    - Las acciones producen transiciones entre *estados* y las *funciones de valor* se calculan sobre dichos estados.

    - Es el tipo de planificación comunmente empleada en RL.
  ]


  - _Es el tipo de planificación que vamos a considerar._

]


// *****************************************************************************

#slide(title: [Tipos de planificación])[

  #framed(title: [Planificación sobre el espacio de planes])[
    Búsqueda a lo largo del espacio de planes/estrategias.

    - Las operaciones llevadas a cabo consisten en transformar un plan/estrategia en otro/a diferente.

    - Las funciones de valor (si las hay) se definen sobre el #stress[espacio de planes].

    - Estos métodos de planificación no son apropiados para problemas de decisión secuenciales y estocásticos como los que se abordan en RL, pero son comunes en otros ámbitos de la IA.
  ]

]


// *****************************************************************************

#slide(title: [Planificación sobre el espacio de estados])[

  Todo método de #stress[planificación sobre el espacio de estados] guarda una misma estructura:

  1. *Calcular las funciones de valor* como paso intermedio y fundamental de cara a mejorar la *política* existente.

  2. Dicho cálcula se realiza mediante *actualizaciones* u *operaciones de _backup_* aplicadas a experiencia simulada.

  #align(center)[#image("images/state-space-plan.png")]

]


// *****************************************************************************

#slide(title: [Ejemplo: programación dinámica])[

  #align(center)[#image("images/state-space-plan.png")]

  1. Se realizan pasadas a lo largo del espacio de estados.

  2. Se genera, para cada estado, la distribución de todas las posibles transiciones.

  3. Cada distribución se emplea para calcular un valor _backup_. Este se utilizará como objetivo en las actualizaciones de los valores (el _update target_).

  4. Se actualiza el valor estimado del estado.


]


// *****************************************************************************

#slide(title: [Planificación sobre el espacio de estados])[

  Otros métodos de planificación sobre el espacio de estados *se ajustan también a esta estructura*, variando únicamente:

  1. La *forma de actualizar* los valores.

  2. El *orden* en que se realizan estas actualizaciones.

  3. Cuánto *tiempo* se mantiene la información retenida (_backed-up_).

  #v(0.7cm)

  #align(center)[#image("images/state-space-plan.png")]
]


// *****************************************************************************

#slide(title: [Planificación _vs._ aprendizaje])[

  La diferencia entre planificaicón y aprendizaje es que...

  - la #stress[planificacion] emplea experiencia simulada, generada por un *modelo*,
  - ...mientras que el #stress[aprendizaje] se basa en experiencia real generada por el *entorno*.

  #framed[Tanto *planificacion* como *aprendizaje* buscan estimar las funciones de valor mediante operaciones _backup_.]

  - Esto permite que múltiples ideas y algoritmos puedan transferirse de unos métodos a otros.

  - Por ejemplo, métodos de aprendizaje que emplean experiencia simulada en vez de experiencia real.

]


// *****************************************************************************

#slide(title: [Ejemplo: _Random-sample one-step tabular Q-planning_])[

  #align(center)[#image("images/q-plan.png")]

  La diferencia entre #stress[_Q-learning_] y #stress[_Q-planning_] es de dónde proviene la información empleada para mejorar la política (entorno real _vs._ modelo del entorno).

]


// *****************************************************************************

#title-slide("Dyna")


// *****************************************************************************

#slide(title: [Planificación _online_])[

  La *experiencia* de un agente puede emplearse para:

  #framed[1. *Mejorar su modelo del entorno* (hacerlo más preciso).]
  #h(1cm) #emoji.circle.blue Aprendizaje del modelo (#stress[_Model learning_])

  #framed[2. *Mejorar la estimación de la función de valor y la política*]
  #h(1cm) #emoji.circle.yellow RL directo (#stress[_DIRECT reinforcement learning_])

  #h(1cm) #emoji.circle.green RL indirecto (#stress[_INDIRECT reinforcement learning_])
]


// *****************************************************************************

#slide(title: [Planificación _online_])[
  La relación entre *experiencia*, *modelo*, *función de valor* y *política* es la siguiente:
  #align(center)[#image("images/dynaq-diagram.png", width: 50%)]
]


// *****************************************************************************

#slide(title: [RL directo _vs._ indirecto])[
  #box(height: 400pt)[

    #text(size: 16pt)[
      La #stress[experiencia] sirve para mejorar las funciones de valor y las políticas, ya sea *directa* o *indirectamente* a partir del modelo.

      #columns(2)[

        #framed[#emoji.circle.green *RL indirecto* (#stress[_INDIRECT RL_]): permite obtener una buena política con pocas interacciones con el entorno real.]

        - Se basa en la *planificación* a partir del modelo.

        #framed[#emoji.circle.yellow *RL directo* (#stress[_DIRECT RL_]): es una solución más simple que no se ve afectada por sesgos en el diseño del modelo.]

        - *Aprendizaje* basado en la interacción directa con el entorno real.

        #colbreak()

        #v(.8cm)

        #align(center)[#image("images/dynaq-diagram.png")]
      ]
    ]
  ]
]

// *****************************************************************************

#slide(title: [Pregunta...])[

  #align(center)[#framed[¿En qué se diferencia *planificación* de *aprendizaje*?]]

]


// *****************************************************************************

#slide(title: [Pregunta...])[

  #align(center)[#framed[¿En qué se diferencia *planificación* de *aprendizaje*?]]

  #text(size: 20pt)[
    #emoji.page La #text(fill:blue)[*planificación*] *decide una secuencia de acciones antes de que se tomen*, basándose en un modelo del entorno predefinido.
    - Se emplea cuando contamos con un modelo fiable, o cuando la interacción con el entorno es costosa/arriesgada.
    - Ej. programación dinámica.

    #emoji.brain El #text(fill:olive)[*aprendizaje*] sí *requiere de la experiencia con el entorno*, ya sea para aprender las funciones de valor/política directamente (_direct RL_), o indirectamente (_indirect RL_) a través de un modelo ajustado con la experiencia obtenida.
    - Se emplea cuando no hay un modelo del entorno, o es incompleto.
    - Ej. métodos basados en TD.
  ]
]

// *****************************************************************************

#title-slide("Dyna-Q")


// *****************************************************************************

#slide(title: [Dyna-Q])[

  #framed(
    title: [Dyna-Q],
  )[Arquitectura de agente que integra #stress[planificación], #stress[actuación] y #stress[aprendizaje] de forma *_online_*.]

]

// *****************************************************************************

#slide(title: [Arquitectura de Dyna-Q])[
  #align(center)[
    #box(height: 450pt)[
      #image("images/dynaq.png")
    ]
  ]
]

// *****************************************************************************

#slide(title: [Arquitectura de Dyna-Q])[
  #align(center)[
    #box(height: 450pt)[
      #image("images/dynaq-2.png")
    ]
  ]
]


// *****************************************************************************

#slide(title: [Modelo en Dyna-Q])[

  #box(height: 450pt)[

    #framed[
      Al *modelo* se le consulta un par #stress[estado--acción] previamente experimentado, y devuelve los siguientes #stress[estado--recompensa] como predicción.
    ]

    #grayed[ $ m(S_t, A_t) --> S_(t+1), R_(t+1) $]

    Contar con un buen modelo suponer necesitar de menos experiencia *real* para alcanzar una misma política $arrow$ se reducen las interacciones con el entorno.

  ]

]


// *****************************************************************************

#slide(title: [Control de búsqueda])[

  #cols[
    Se denomina #stress[control de búsqueda] (_search control_) al proceso de selección del estado--acción inicial en la *experiencia simulada* obtenida del *modelo* y empleada para aprender mediante *planificación*.
  ][
    #align(center)[#image("images/search-control.png")]
  ]

]


// *****************************************************************************

#slide(title: [Método de aprendizaje])[

  Generalmente, Dyna-Q emplea el #stress[mismo método] para el *aprendizaje* a partir de experiencia *real* y *simulada* (ej. _1-step Q-learning_).

  #v(.4cm)

  #framed[#stress[Aprendizaje] y #stress[planificación] solamente varían en la *procedencia* de la *experiencia* empleada (entorno real o modelo del entorno).]
]


// *****************************************************************************

#slide(title: [Procesos en Dyna-Q])[

  Conceptualmente, la *planificación*, *actuación*, *aprendizaje del modelo* y *aprendizaje directo mediante RL* ocurren #stress[simultáneamente].

  No obstante, la implementación de Dyna-Q de forma secuencial requiere dividir estos procesos dependiendo de sus #stress[requisitos computacionales]:

  #columns(2)[

    #framed[
      - *Actuación*
      - *Aprendizaje del modelo*
      - *RL directo*
      Ocurren rápidamente y prácticamente en paralelo.
    ]

    #colbreak()

    #framed[
      - *Planificación*
      Implica operaciones más costosas que requieren un mayor tiempo de ejecución.
    ]
  ]
]


// *****************************************************************************

#slide(title: [Dyna-Q tabular])[
  #box(height: 450pt)[
    #align(center)[#image("images/tabular-dynaq.png")]
  ]
]


// *****************************************************************************

#slide(title: [Dyna-Q])[
  #box(height: 450pt)[

    #align(center)[#image("images/tabular-dynaq.png", width: 75%)]

    #v(0.5cm)

    #columns(3)[

      #text(size: 15pt)[
        *(a)* Percibir estado

        *(b)* Seleccionar acción

        *(c)* #stress[Actuar] y observar transición

        #colbreak()

        #h(20pt) *(d)* #stress[RL directo]

        #h(20pt) *(e)* #stress[Aprendizaje del modelo]

        #h(20pt) *(f)* #stress[Planificación]

        #colbreak()

        Si eliminamos *(e)* y *(f)*, tenemos el _1-step tabular Q-learning_ convencional.

        Los dos primeros pasos en *(f)* se corresponden con _search control_.

      ]
    ]

  ]
]


// *****************************************************************************

#slide(title: [Dyna-Q])[
  #box(height: 450pt)[

    #v(.8cm)
    #align(center)[#image("images/tabular-dynaq.png", width: 75%)]

    #columns(2)[

      #text(size: 17pt)[

        #framed[Se realizan tantas #stress[iteraciones de planificación] ($n$) como se especifiquen en *(f)*.
        ]

        #colbreak()

        #framed[Si $n = 0$, tenemos un agente de RL convencional (_direct RL_) que no planifica.]

        #colbreak()

      ]
    ]

  ]
]


// *****************************************************************************

#slide(title: [Planificación])[
  #box(height: 450pt)[
    En la práctica, invertir en planificación puede suponer un #stress[aprendizaje más rápido]...
    #align(center)[#image("images/example-dynaq.png", width: 65%)]
  ]
]


// *****************************************************************************

#slide(title: [Planificación])[
  #box(height: 450pt)[

    En la práctica, invertir en planificación puede suponer un #stress[aprendizaje más rápido]...

    #v(1cm)

    #align(center)[#image("images/example-dynaq-2.png")]

  ]
]


// *****************************************************************************

#slide(title: [Dyna-Q])[
  #box(height: 450pt)[

    #framed(
      title: text(
        size: 17pt,
      )[#emoji.books Sutton, R. S., & Barto, A. G. (2018). _Reinforcement learning: An introduction_. MIT press.],
    )[
      #set text(size: 18pt)
      #v(0.5cm)

      _In #stress[Dyna-Q], *learning* and *planning* are accomplished by exactly the same algorithm, operating on *real experience* for *learning* and on *simulated experience* for *planning*. Because planning proceeds incrementally, it is trivial to *intermix* planning and acting. Both proceed as fast as they can._

      #v(.7cm)

      _The agent is always reactive and always deliberative, responding instantly to the latest sensory information and yet always planning in the background. Also ongoing in the background is the *model-learning process*. As new information is gained, the model is *updated* to better *match reality*. As the model changes, the ongoing *planning* process will gradually compute a different way of behaving to *match* the new model._

      #v(0.5cm)

    ]

  ]
]

// *****************************************************************************

#focus-slide([Hablando en código...])


// *****************************************************************************

#slide(title: [Dyna-Q])[
  #align(center)[
    #box(height: 400pt)[
      #text(size: 18pt)[
        ```python
        def dynaq(self, env, n_episodes, plan_steps, alpha, gamma, epsilon):

          q_table, model = {}, {}

          for _ in range(n_episodes):
            s = env.start_pos
            while True:

                if s not in self.q_table:
                    q_table[s] = {action: 0 for action in env.actions}

                a = e_greedy(s, actions, epsilon)

                s_next, r, end = env.step(s, a)

                if s_next not in self.q_table:
                    self.q_table[s_next] = {
                        action: 0 for action in env.actions}
               ...
        ```
      ]
    ]
  ]
]


// *****************************************************************************

#slide(title: [Dyna-Q])[
  #align(center)[
    #text(size: 22pt)[
      ```python
              ...

              # Q-learning update
              td_target = r + gamma * max(q_table[s_next].values())
              td_error = td_target - q_table[s][a]
              q_table[s][a] += alpha * td_error

              # Update Model
              if s not in model:
                  model[s] = {}
              model[s][a] = (s_next, r)

              ...
      ```
    ]
  ]
]


// *****************************************************************************

#slide(title: [Dyna-Q])[
  #align(center)[
    #box(height: 500pt)[
      #text(size: 20pt)[
        ```python
                ...

                # Planning
                for _ in range(plan_steps):
                    sim_s = random.choice(list(self.model.keys()))
                    sim_a = random.choice(list(self.model[sim_s].keys()))

                    sim_s_next, sim_r = self.model[sim_s][sim_a]

                    sim_td_target = sim_r + self.gamma * \
                        max(self.q_table[sim_s_next].values())
                    sim_td_error = sim_td_target - self.q_table[sim_s][sim_a]
                    self.q_table[sim_s][sim_a] += self.alpha * sim_td_error

                s = s_next

                if end:
                    break

        ```
      ]
    ]
  ]
]


// *****************************************************************************

#focus-slide([¿Qué ocurre si el modelo NO es preciso?])


// *****************************************************************************

#slide(title: [Modelos imprecisos])[
  #box(height: 450pt)[

    Si un *modelo* del entorno *no es preciso*, las transiciones predichas no son correctas.

    - Es decir, la función de transición $p(s,a|s',r)$ modelada *no se ajusta a la realidad*.

    #framed[Los errores en los modelos se deben a la #stress[estocasticidad] de los entornos en combinación con la #stress[falta de experiencia].]

    Si el entorno cambia con el tiempo, un modelo aprendido puede dejar de ser útil.

    #text(
      size: 15pt,
    )[_Otra posibilidad es que el modelo empleado generalice de forma imperfecta, en caso de que sea un modelo obtenido mediante aproximación de funciones._]

  ]
]


// *****************************************************************************

#slide(title: [Errores en los modelos])[
  #box(height: 450pt)[

    Por tanto...

    + Modelos que no contienen todas las *transiciones* $->$ #text(fill:red)[*MODELOS INCOMPLETOS*]

    + Modelos imprecisos porque el *entorno* ha variado $->$ #text(fill:blue)[*MODELOS DESACTUALIZADOS*]

  ]
]


// *****************************************************************************

#slide(title: [Ejemplo])[
  #align(center)[
    #image("images/env-change.png")
  ]
]


// *****************************************************************************

#slide(title: [Modelos imprecisos])[

  #framed[¿Qué ocurre si *planificamos* con modelos imprecisos?]

  #v(.4cm)

  - Si el modelo es *incompleto*, necesitamos tiempo para #stress[almacenar transiciones y obtener experiencia].

  - Si el modelo *difiere de la realidad* porque el *entorno* real ha cambiado, la política/función de valor puede actualizarse en una #stress[dirección errónea].

]


// *****************************************************************************

#slide(title: [Políticas subóptimas])[


  #framed[Cuando el modelo es incorrecto, la planificación da lugar a #stress[políticas subóptimas].]

  En algnos casos, la política subóptima obtenida mediante planificación puede llevar al #stress[descubrimiento] y #stress[corrección] de los *errores* del modelo.

  - Esto ocurre principalmente cuando el modelo es *optimista* y se predicen mejores recompensas o transiciones de las que son realmente posibles.

  - La política subóptima trata de explotar estas oportunidades y de esta forma descubre que *sus expectativas son falsas*.


]


// *****************************************************************************

#slide(title: [Modelos en entornos estocásticos])[

  Para el agente, es necesario mantener la certeza de que su modelo se encuentra correctamente actualizado.

  La *exploración* le permite asegurar la precisión del modelo, al mismo tiempo que se dedica a la *explotación* de la política óptima (asumiendo que es correcta).

]


// *****************************************************************************

#slide(title: [Modelos imprecisos con Dyna-Q])[

  Una ventaja de #stress[Dyna-Q] es que permite planificar aun contando con un modelo incompleto, ya que sólo muestrea estados y acciones que hayan sido *previamente visitados*. Véanse los primeros dos pasos de *(f)*:

  #align(center)[#image("images/tabular-dynaq.png", width: 80%)]

]

// *****************************************************************************

#title-slide([Dyna-Q+])


// *****************************************************************************

#slide(title: [Dyna-Q+])[

  #framed[Es más probable que un #stress[modelo] esté *desactualizado* en #stress[estados/acciones] que lleven más *tiempo sin visitarse*.]

  Para asegurar que el agente revisita estados periódicamente, podemos añadir un "*bonus*" a la recompensa empleada en la planificación.

  Esta es la propuesta del algoritmo #stress[Dyna-Q+].

]


// *****************************************************************************

#slide(title: [Dyna-Q+])[

  #align(center)[#image("images/dynaq+.png")]

]


// *****************************************************************************

#slide(title: [Dyna-Q+])[

  #cols[

    #align(center)[#image("images/dynaq+.png")]

    #framed[#stress[Dyna-Q+] mantiene un registro de los *_time steps_ transcurridos desde la última ocurrencia* de cada par acción--estado en el entorno real.]

  ][

    Cuanto más tiempo haya transcurrido, se asume una mayor probabilidad de que las dinámicas asociadas a un par acción--estado hayan cambiado y que, por tanto, el modelo sea *incorrecto*.

    - Para favorecer que "se vuelva intentar", se añade un #stress[_bonus_] a la recompensa de las experiencias simuladas que impliquen al par poco visitado.

  ]

]


// *****************************************************************************

#slide(title: [Dyna-Q+])[

  #cols[



    #align(center)[#image("images/dynaq+.png")]


    Si la recompensa de una transición es $r$ y la transición no se ha probado desde hace $tau$ _time steps_, la recompensa de esa transición pasa a ser #stress[$r + kappa sqrt(tau)$], siendo $kappa$ un valor pequeño.
  ][

    #grayed[$ r' = r + kappa sqrt(tau) $]

    Se promueve que el agente revisite estados cada _X_ tiempo para confirmar que el modelo esté actualizado.

    Se actualiza la *política* para dirigir al agente a *estados/acciones no visitados* desde hace tiempo.

    De esta forma, mantenemos el #stress[modelo actualizado].

  ]

]


// *****************************************************************************

#slide(title: [Ejemplo])[
  #align(center)[
    #cols[
      #image("images/dyna-q-comparison.png")
    ][
      #image("images/dyna-q-comparison-2.png", width: 120%)
    ]
  ]
]

// *****************************************************************************

#title-slide("Trabajo propuesto")

// *****************************************************************************

#slide(title: "Trabajo propuesto")[

  #box(height: 500pt)[
    #text(size: 18pt)[

      - Analiza esta *implementación de DynaQ* y trata de hacer la tuya:

        - #text(size: 16pt)[#link("https://github.com/manjavacas/rl-temario/tree/main/ejemplos/dynaq")]

        - Pruébala en un entorno de *Gymnasium* (ej. _Frozen Lake_).

      - Leer capítulos _*8.6. Trajectory Sampling*_ y _*8.11. Monte Carlo Tree Search*_ de Sutton, R. S., & Barto, A. G. (2018). Reinforcement learning: An introduction.

        - _¿Conoces alguna aplicación conocida donde se haya utilizado #stress[Monte Carlo Tree Search]?_

      *Bibliografía y recursos*

      #text(size: 14pt)[
        - *Capítulo 8* de Sutton, R. S., & Barto, A. G. (2018). Reinforcement learning: An introduction.
        - https://youtu.be/ItMutbeOHtc?si=XFPMlOxD6MZNQgUy
        - https://youtu.be/jlC0TFTUefs?si=O_L4fL6ddW8X1N_U
        - https://youtu.be/aUjuBvqJ8UM?si=lU11f24dn27LnISD
        - https://www.davidsilver.uk/wp-content/uploads/2020/03/dyna.pdf

      ]
    ]
  ]
]

// *****************************************************************************

#front-slide(
  title: "Aprendizaje por refuerzo",
  subtitle: [Planificación],
  authors: "Antonio Manjavacas",
  info: "manjavacas@ugr.es",
)
