class CertificateManager
  attr_accessor :user_contest_id

  def initialize(ucid)
    @user_contest_id = ucid
  end

  def create_and_give
    clean_files_without_delay

    user_contest = UserContest.find(user_contest_id)

    filename = "#{user_contest.id}.tex"
    pdf_filename = "#{user_contest.id}.pdf"
    name = user_contest.user.fullname
    award = user_contest.award
    contest = user_contest.contest.name

    contents = nil
    if award == ''
      contents = 'telah berpartisipasi dalam'
    else
      contents = "telah meraih

      {\\color{emphasis} \\large Medali #{award}}

      pada"
    end

    tex = "\\documentclass[17pt]{extarticle}

    \\usepackage[T1]{fontenc} % Encoding
    \\usepackage{DejaVuSans} % Font
    \\renewcommand*\\familydefault{\\sfdefault} % Sans Serif base

    \\usepackage[dvipsnames]{xcolor} % Color some text
    \\usepackage{graphicx} % Graphics support
    \\usepackage[a4paper,landscape,left=2cm,right=2cm,top=2.3cm,bottom=2.3cm]{geometry} % Margins
    \\usepackage{background} % Background for frame

    \\definecolor{emphasis}{HTML}{1435B0}

    \\linespread{1.3}

    \\backgroundsetup{
      scale=1,
      angle=0,
      contents={
        \\includegraphics[width=\\paperwidth,height=\\paperheight]{frame.jpg}
      }
    }

    \\begin{document}
    \\pagenumbering{gobble}
    \\centering{

    \\includegraphics[width=10cm]{logo.png}

    \\vspace{1em}

    {\\Large PENGHARGAAN}

    \\vspace{1em}

    {\\color{emphasis} \\large #{name}}

    #{contents}

    {\\color{emphasis} \\large #{contest}}

    \\vfill

    \\begin{minipage}{0.4\\textwidth}
      \\centering
      \\includegraphics[height=2cm]{ilhan.png}

      \\small{Herbert Ilhan Tanujaya

      Ketua KTO Matematika}
    \\end{minipage}
    \\begin{minipage}{0.4\\textwidth}
      \\centering
      \\includegraphics[height=2cm]{barra.png}

      \\small{Aleams Barra

      Ketua TOMI}
    \\end{minipage}
    }
    \\end{document}"

    File.write("public/certificates/#{filename}", tex)
    2.times { `pdflatex #{filename}` } # to render pdf correctly
    "public/certificates/#{pdf_filename}"
  end

  def clean_files
    File.delete("public/certificates/#{user_contest_id}.tex")
    File.delete("public/certificates/#{user_contest_id}.pdf")
  end
  handle_asynchronously :clean_files, run_at: proc { 5.minutes.from_now },
                                      queue: 'delete_certificates'
end
