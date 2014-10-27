ngs_recipes
===========
Set up Next-Generation Sequencing tools.

For Ubuntu 14.04 LTS.

* vicuna
* bwa
* samtools
* bowtie
* bowtie2
* fastx_toolkit

1. repipe取得

    git clone https://github.com/t-oginogin/ngs_recipes.git /ngs/

2. lohalhost.json内のパラメータを適宜変更

3. solo.rb内のcookbook_pathを適宜変更

4. vicuna.zipを次のサイトからダウンロード（ユーザー登録が必要）

    http://www.broadinstitute.org/scientific-community/science/projects/viral-genomics/vicuna

5. vicuna.zipを/ngs/tmp/に配置

6. recipe実行

    sudo chef-solo -c solo.rb -j ./localhost.json
