#!/usr/bin/env bash
#
# This is Bash shell script dvs.sh
#
if [ $# -eq 0 ]; then
    echo "Usage: ./dvs.sh [clean|check|typeset|produce|push]" 1>&2
    echo "    clean:   remove generated files and clean source repository" 1>&2
    echo "    check:   compute and verify SHA224 checksums against dvs.sha" 1>&2
    echo "    typeset: typeset the whole document one step at a time" 1>&2
    echo "    produce: produce the whole document from raw LaTeX sources" 1>&2
    echo "    push:    prepare the repository for a GitLab/GitHub push" 1>&2
    exit 1
elif [ $# -gt 1 ]; then
    echo "Usage: ./dvs.sh [clean|check|typeset|produce|push]" 1>&2
    echo "    clean:   remove generated files and clean source repository" 1>&2
    echo "    check:   compute and verify SHA224 checksums against dvs.sha" 1>&2
    echo "    typeset: typeset the whole document one step at a time" 1>&2
    echo "    produce: produce the whole document from raw LaTeX sources" 1>&2
    echo "    push:    prepare the repository for a GitLab/GitHub push" 1>&2
    exit 1
else
    case "$1" in
        clean)
            rm -f tex/*.aux
            rm -f dvs.{aux,bbl,bcf,blg,log,pdf,res,run.xml,sha,toc}
            rm -f dvs.{idxa,idxd,idxn,idxp,idxu,idxw}
            rm -f dvs.{ilga,ilgd,ilgn,ilgp,ilgu,ilgw}
            rm -f dvs.{inda,indd,indn,indp,indu,indw}
            find ./ -type f | xargs sha224sum | egrep -v 'dvs.sha$' | sort > dvs.sha
            ./dvs.sh check
            ;;
        check)
            if [ -f "dvs.sha" ]; then
                sha224sum --check --quiet dvs.sha
            else
                echo "Checksums database file does not exist" 1>&2
            fi
            ;;
        typeset)
            if [ -f "dvs.bcf" ]; then
                biber --isbn-normalise dvs.bcf
            fi
            if [ -f "dvs.idxa" ]; then
                xindy -o dvs.inda -t dvs.ilga -C utf8 -L general -M xdy/dvs_a.xdy dvs.idxa
            fi
            if [ -f "dvs.idxd" ]; then
                xindy -o dvs.indd -t dvs.ilgd -C utf8 -L general -M xdy/dvs_d.xdy dvs.idxd
            fi
            if [ -f "dvs.idxn" ]; then
                xindy -o dvs.indn -t dvs.ilgn -C utf8 -L general -M xdy/dvs_n.xdy dvs.idxn
            fi
            if [ -f "dvs.idxp" ]; then
                xindy -o dvs.indp -t dvs.ilgp -C utf8 -L general -M xdy/dvs_p.xdy dvs.idxp
            fi
            if [ -f "dvs.idxu" ]; then
                xindy -o dvs.indu -t dvs.ilgu -C utf8 -L general -M xdy/dvs_u.xdy dvs.idxu
            fi
            if [ -f "dvs.idxw" ]; then
                xindy -o dvs.indw -t dvs.ilgw -C utf8 -L general -M xdy/dvs_w.xdy dvs.idxw
            fi
            if [ -f "dvs.tex" ]; then
                ln -s cls/dvs.cls dvs.cls
                lualatex dvs.tex
                rm -f dvs.cls
                qpdf --linearize dvs.pdf dvslin.pdf
                rm -f dvs.pdf
                mv dvslin.pdf dvs.pdf
            fi
            if [ -f "dvs.blg" ]; then
                echo 'Checking Biber log file...'
                egrep -v 'INFO' dvs.blg
                echo '... done.'
            fi
            if [ -f "dvs.log" ]; then
                echo 'Checking LuaTeX log file...'
                egrep '^!|Error|Warning|Missing|Overfull|Underfull' dvs.log
                echo '... done.'
            fi
            find ./ -type f | xargs sha224sum | egrep -v 'dvs.sha$' | sort > dvs.sha
            ./dvs.sh check
            ;;
        produce)
            find ./ | xargs touch
            ./dvs.sh clean
            number=0
            while [ "$number" -lt 6 ]
            do
                ./dvs.sh typeset
                number=$(expr $number + 1)
            done
            ./dvs.sh check
            find ./ | xargs touch
            ;;
        push)
            rm -f tex/*.aux
            rm -f dvs.{aux,bbl,bcf,blg,log,res,run.xml,sha,toc}
            rm -f dvs.{idxa,idxd,idxn,idxp,idxu,idxw}
            rm -f dvs.{ilga,ilgd,ilgn,ilgp,ilgu,ilgw}
            rm -f dvs.{inda,indd,indn,indp,indu,indw}
            find ./ -type f | xargs sha224sum | egrep -v 'dvs.sha$' | sort > dvs.sha
            ./dvs.sh check
            find ./ | xargs touch
            ;;
        *)
            echo "Usage: ./dvs.sh [clean|check|typeset|produce|push]" 1>&2
            echo "    clean:   remove generated files and clean source repository" 1>&2
            echo "    check:   compute and verify SHA224 checksums against dvs.sha" 1>&2
            echo "    typeset: typeset the whole document one step at a time" 1>&2
            echo "    produce: produce the whole document from raw LaTeX sources" 1>&2
            echo "    push:    prepare the repository for a GitLab/GitHub push" 1>&2
            exit 1
            ;;
    esac
fi
exit
