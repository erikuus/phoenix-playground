defmodule LivePlaygroundWeb.DevHelpers do
  def lorem_ipsum_words(count) do
    String.split(lorem_ipsum(), " ", trim: true)
    |> Enum.slice(0..(count - 1))
    |> Enum.join(" ")
  end

  def lorem_ipsum_sentences(count) do
    sentences =
      String.split(lorem_ipsum(), ".", trim: true)
      |> Enum.slice(0..(count - 1))
      |> Enum.join(". ")

    "#{sentences}."
  end

  def lorem_ipsum_paragraphs(count) do
    String.split(lorem_ipsum(), "\n\n", trim: true)
    |> Enum.slice(0..(count - 1))
    |> Enum.join("\n\n")
  end

  defp lorem_ipsum() do
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur ut odio sed felis iaculis scelerisque. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ultrices lectus quam, nec ultrices felis sagittis a. Curabitur quis fringilla enim. In feugiat purus vel nibh sodales, at rutrum mauris auctor. Aenean justo ex, luctus et sodales et, imperdiet eget felis. Interdum et malesuada fames ac ante ipsum primis in faucibus. Donec imperdiet nibh ac mauris tempor euismod. Etiam ac enim volutpat nisl rutrum vulputate vulputate sit amet nisi. Nullam efficitur efficitur tempor. Maecenas ligula arcu, auctor euismod gravida eu, rhoncus vel nibh. Cras odio orci, elementum scelerisque justo sed, auctor sollicitudin ligula. Sed molestie ipsum ut maximus rhoncus. Nunc dapibus massa quis quam rutrum auctor. Aliquam malesuada sed augue eu efficitur. Duis mi quam, pellentesque vitae porta sit amet, rhoncus a ex.

    Morbi sed rutrum sem, quis pretium nisl. Vestibulum sed malesuada arcu. Donec ac lacus non nibh blandit porta vitae eget odio. Nulla sollicitudin nisi feugiat ipsum commodo mattis. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus cursus sollicitudin ligula, eu dapibus massa ullamcorper a. Donec nec condimentum elit. Suspendisse sed luctus nibh. Curabitur vehicula tincidunt libero ac venenatis. Aliquam quam lectus, congue eget posuere et, dignissim et odio. Quisque quis lacus sit amet erat tincidunt hendrerit eget at libero. Praesent venenatis turpis sed nunc pulvinar volutpat. Nullam et tincidunt quam, in dignissim neque. Vestibulum porttitor dui ut eros euismod sagittis elementum nec est. Integer eleifend imperdiet ante eget dapibus. Nullam facilisis non turpis non vestibulum.

    Phasellus ultrices gravida dolor vitae aliquet. Duis molestie purus ante, non aliquet mi faucibus sed. Sed mauris sapien, lacinia eget lacinia ut, tincidunt ac lectus. Nulla auctor, massa id pharetra iaculis, turpis ante gravida justo, vel consequat tortor arcu nec est. Fusce tellus arcu, ultrices vel venenatis vel, venenatis id diam. Vestibulum iaculis consequat lobortis. Maecenas lorem turpis, sodales non turpis in, cursus tempor nisi. Integer at ipsum sed metus pellentesque facilisis id non urna. Suspendisse potenti. Vivamus sollicitudin pulvinar risus id aliquam. Morbi finibus volutpat neque, et condimentum nisi fringilla eu. Aenean tristique aliquam ipsum at aliquet. Nullam cursus massa nec ligula accumsan, non efficitur orci eleifend.

    Sed ornare diam risus, quis condimentum odio ornare eget. Nullam in nunc vel magna interdum fermentum eget id arcu. Sed semper ex nec felis consectetur, sit amet malesuada erat placerat. Sed et bibendum felis. Nam sed justo vel arcu sollicitudin vestibulum eu non quam. Fusce dapibus turpis quis placerat mattis. Nam ac aliquet neque. Nulla consectetur massa ut blandit laoreet. Nam facilisis semper ex sit amet ornare. Vestibulum sodales augue vitae varius porta. Mauris euismod blandit tempor. Duis porta nunc diam, sit amet euismod metus malesuada vel. Sed sed nunc mi.

    Sed eget porttitor tellus. Nullam at commodo odio. Fusce tincidunt venenatis tincidunt. Vestibulum nec feugiat lacus. Sed sit amet lectus quis sapien tristique placerat. Praesent condimentum justo eget nulla pharetra tincidunt. Maecenas commodo ex quis felis finibus maximus. Sed bibendum elit sed velit elementum, sed molestie augue ornare. Mauris mattis porta augue, vel ultrices justo ornare a. Praesent rhoncus, nunc ut pellentesque mollis, nisi metus molestie lectus, at fermentum quam neque eget lectus. Nullam in aliquet ex.

    Morbi quis pulvinar diam. Morbi lacinia, lectus in viverra auctor, nisi odio vulputate lorem, et posuere ligula massa id ante. Nunc ac faucibus lorem, ac dapibus metus. Vivamus eget ante sed enim laoreet hendrerit. Aenean ultrices quam urna, eget elementum dui mattis interdum. Suspendisse suscipit pellentesque risus, at commodo elit vulputate sit amet. Interdum et malesuada fames ac ante ipsum primis in faucibus. Nam sodales mollis sem, ut volutpat diam. Aenean eleifend quis lorem at cursus. Phasellus quis nisl non nibh lobortis auctor ut nec velit. Donec lacus nisi, porttitor eu dui nec, posuere ultrices orci. Vestibulum non hendrerit urna, vel bibendum neque. Mauris ut est blandit neque aliquet imperdiet. Maecenas tempus felis sem, aliquam laoreet felis euismod quis. Sed dapibus ante mattis velit sagittis, eu placerat sem pharetra.

    Donec elementum maximus est non efficitur. Nulla sollicitudin ultrices volutpat. Duis tempus eleifend tellus, et vehicula lorem luctus in. Sed in eros ac ante bibendum elementum. Duis egestas cursus ipsum, non dictum tortor gravida in. Integer ut mollis orci. Duis eu varius tortor, sed finibus ante. Maecenas efficitur blandit erat volutpat pellentesque. Donec condimentum, dolor id lobortis vehicula, leo massa placerat purus, non porttitor nunc ex eu dolor. In lobortis convallis libero, sit amet commodo mauris dapibus auctor. Nulla placerat feugiat ullamcorper. Ut rhoncus pellentesque diam, ac finibus neque ullamcorper sit amet. Nulla iaculis aliquam leo vitae volutpat. Etiam vitae iaculis enim, ac pellentesque dui. Nullam suscipit, elit tincidunt accumsan sollicitudin, diam massa rutrum mauris, eget ultrices justo lorem ac tellus.

    Fusce eget ex at quam faucibus iaculis. Morbi a pharetra enim. Sed sollicitudin enim lorem. Nam venenatis efficitur odio. Mauris rhoncus elit eget augue convallis, nec pharetra tellus interdum. Maecenas sed mi eget orci elementum ornare vel eu sapien. In interdum neque at nibh dignissim, eu pretium quam consequat. Nullam elementum, lacus sit amet aliquam eleifend, erat mi eleifend arcu, ac dapibus felis sapien a neque. Donec eget efficitur justo, nec facilisis est. Nulla venenatis sem in felis condimentum, convallis mollis eros dignissim. Duis elit nulla, pulvinar vehicula bibendum a, elementum a risus. Nunc ac quam sed leo gravida fermentum id nec leo. Vivamus ac orci nec ex suscipit mollis id vel nisi. Curabitur sed tincidunt nibh.

    Etiam hendrerit sem in odio vulputate maximus. Morbi eu risus ut lorem pharetra egestas. Maecenas quis ante semper, scelerisque orci eget, dignissim eros. Sed rutrum lorem at suscipit blandit. Nullam a viverra nibh. Praesent congue varius aliquet. Phasellus placerat rutrum ante viverra ultricies. In ut efficitur magna. Suspendisse eleifend a arcu eu aliquam.

    Aenean vulputate velit bibendum massa accumsan ornare. Sed dolor arcu, mattis a vehicula vel, sollicitudin a elit. Vestibulum quam erat, semper interdum nulla at, aliquet rutrum nisl. Aenean lacus lorem, vulputate sit amet sodales nec, aliquam id nibh. Donec sit amet condimentum ex. Pellentesque ac erat sed lacus posuere interdum sed sed purus. Sed maximus nisl nec rutrum dapibus. Sed dignissim molestie nibh vitae malesuada. Ut nunc est, cursus eget pellentesque ut, posuere laoreet est. Sed sit amet ante vitae lorem volutpat elementum a quis justo. In lacinia vulputate tellus ut semper. Praesent blandit, tellus et vehicula cursus, massa tellus rhoncus turpis, consequat faucibus ante elit quis arcu. Suspendisse eu erat quis dolor porta lobortis ut sed lorem."
  end
end
