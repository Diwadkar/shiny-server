
#Install ui libraries in path /usr/local/lib/R/site-library
###
#

#Footer
footstyle = "position:fixed;
       bottom:0;
right:0;
left:0;
background:#EBF4FA;
padding:5px;
box-sizing:border-box;"

ui <- shinyUI(fluidPage(theme = shinytheme("lumen"),
                        h3(strong("Reducing Associations by Linking Genes And omics Results (REALGAR)"), align="center", style = "color: #9E443A;"), hr(),
                        navbarPage( "", 
                                    tabPanel("Results",
                                             wellPanel(fluidRow(align = "left",
                                                                column(12,  
                                                                       fluidRow(h4(strong("Select options:")),align = "left"), 
                                                                       fluidRow(div(style="margin-right: 25px", 
                                                                                    column(3,fluidRow(div(style="margin-left: 25px", checkboxGroupInput("Tissue",label = strong("Tissue:"),
                                                                                           choices = tissue_choices,selected=tissue_choices))),
                                                                                           actionButton("selectall_tissue","Unselect all")),
                                                                                    column(2,fluidRow(checkboxGroupInput(inputId="Asthma", label=strong("Condition vs Healthy:"),choices=asthma_choices,selected=asthma_choices)),
                                                                                           fluidRow(actionButton("selectall_asthma","Unselect all")),br(),
                                                                                           fluidRow(checkboxGroupInput(inputId = "Status", label = strong("Restrict Age Group:"),choices=c("Children"="childhood")))),
                                                                                    column(1, withSpinner(uiOutput("loadProxy"),color= "#9E443A",type=8)),
                                                                                    column(3, fluidRow(checkboxGroupInput(inputId="Treatment", label=strong("Treatment:"), choices = treatment_choices,selected=treatment_choices)),
                                                                                           fluidRow(actionButton("selectall_treatment","Unselect all")),br(),
                                                                                           fluidRow(checkboxGroupInput(inputId = "Experiment", label = strong("Experiment Design:"),choices=c("Cell-based assay"="invitro","Human response study"="invivo"),selected="invitro")),
                                                                                           fluidRow(br(),
                                                                                                    selectizeInput("current", "Official Gene Symbol or SNP ID:", choices=gene_choices[1:200], selected="GAPDH", width="185px", options = list(create = TRUE))),
                                                                                           align="left"),
                                                                                    column(2,
                                                                                           fluidRow(checkboxGroupInput(inputId="which_SNPs", label=strong("GWAS Results:"), 
                                                                                                                       choices=gwas_choices, selected="snp_subs")),
                                                                                           fluidRow(actionButton("selectall_GWAS","Select all")), br(), 
                                                                                           fluidRow(textOutput("GWAS_text")), 
                                                                                           fluidRow(uiOutput("eve_options")),
                                                                                           fluidRow(uiOutput("TAGC_options")), align="left"))),br(),hr(),
                                                                                           fluidRow(column(12, h4(strong("Download results displayed in forestplot and gene track:")),align = "left")),
                                                                                           fluidRow(column(6, downloadButton(outputId="table_download", label="Download gene expression results"), align="left"),
                                                                                                    column(6, downloadButton(outputId="SNP_data_download", label="Download GWAS results"), align="left"))))),
                                                                                                             
                                                       column(width=12,tabsetPanel(tabPanel("Forestplots",br(),
                                                                                            p("Differential expression results for individual microarray and RNA-Sequencing study were obtained using ",
                                                                                              a("RAVED", href="https://github.com/HimesGroup/raved", target="_blank"),
                                                                                              ". Integrated results were obtained using three summary statistics-based approches: ",
                                                                                              "(1) an effect size-based method that applied a random-effects model, ",
                                                                                              "(2) p-value-based method that applied Fisher's sum-of-logs method, ",
                                                                                              "and  (3) rank-based method that adpoted the Rank Product. ",
                                                                                              "Note that p-values from the p-value-based and effect size-based methods are not adjusted for multiple corrections in this app, ",
                                                                                              "so we suggest that users apply a stringent threshold of multiple corrections corresponding to 25,000 genes (i.e. 2x10-6). ",
                                                                                              "For the rank-based method, an analytic rank product is provided instead of the permutated empirical p-value, ",
                                                                                              "so we suggest users refer to the rank score when prioritizing the genes for functional validation. For more information, you can check the References tab."),
                                                                                            
                                                                                            column(12, withSpinner(plotOutput(outputId="forestplot_asthma",width="1200px", height="auto"),color= "#9E443A"), align="center"), #1355px #1250px #1000px
                                                                                                column(12, textOutput("asthma_pcomb_text"), align="center"), # output combined p-values
                                                                                                column(12, downloadButton(outputId="asthma_fc_download",label="Download asthma forest plot"), align="center"), 
                                                                                                column(12, br(), br(), withSpinner(plotOutput(outputId="forestplot_GC",width="1200px", height="auto"),color= "#9E443A"),align="center"),
                                                                                                column(12, textOutput("GC_pcomb_text"), align="center"), # output combined p-values
                                                                                                column(12, downloadButton(outputId="GC_fc_download",label="Download GC forest plot"), align="center"),
                                                                                                column(12, fluidRow(br(), br(), br()))),
                                                                                                                       
                                                                                   tabPanel("Gene Tracks", br(),
                                                                                            p("Transcripts for the selected gene are displayed here. ",
                                                                                              "Any SNPs and/or transcription factor binding sites that fall within the gene ",
                                                                                              "or within +/- 10kb of the gene are also displayed, ",
                                                                                              "each in a separate track. Transcription factor binding sites are colored by the ",
                                                                                              "ENCODE binding score (shown below each binding site), ",
                                                                                              "with the highest binding scores corresponding to the brightest colors. ",
                                                                                              "Only those SNPs with p-value <= 0.05 are included. ",
                                                                                              "SNPs are colored by p-value, with the lowest p-values corresponding to the brightest colors. ",
                                                                                              "All SNP p-values are obtained directly from the study in which the association was published."),br(),
                                                                                                 column(12, downloadButton(outputId="gene_tracks_download", label="Download gene tracks"), align="center"), br(),
                                                                                                 column(12, HTML("<div style='height: 90px;'>"), imageOutput("color_scale3"), align="center", HTML("</div>")), 
                                                                                                 column(12, align="center", plotOutput(outputId="gene_tracks_outp2")),
                                                                                                 column(12, fluidRow(br(), br(), br(),br()))) #tabPanel
                                                                                                 )#tabsetPanel
                                                                                                 )),
                                                                              
                                                     tabPanel("Datasets loaded",
                                                                 column(12,align="left",
                                                                        fluidRow(h4("Gene expression datasets:")),
                                                                        fluidRow(p("For gene expression datasets, the following information is provided:",
                                                                                   "(1) GEO accession numbers that link directly to GEO entries, ", 
                                                                                   "(2) Quality control report generated by RAVED",
                                                                                   "(3) PMIDs for papers, when available, that link directly to PubMed entries, and ", 
                                                                                   "(4) brief descriptions for all gene expression datasets that match selected criteria. "), br()),
                                                                        fluidRow(DT::dataTableOutput(outputId="GEO_table"), br()),
                                                                        fluidRow(h4("GWAS datasets:")),
                                                                        fluidRow(p("For GWAS datasets, the following information is provided:",
                                                                                   "(1) names of the studies selected, which link directly to the study website or publication and",
                                                                                   "(2) brief descriptions for all GWAS studies selected.")),
                                                                        fluidRow(DT::dataTableOutput(outputId="GWAS_table"), br()))),
                                    
                                                 tabPanel("About",
                                                   p("REALGAR is a tissue-specific, disease-focused resource for integrating omics results. ",
                                                     "This app brings together genome-wide association study (GWAS) results, "," transcript data from ",
                                                     a("GENCODE,", href="http://www.gencodegenes.org/", target="_blank"),
                                                     "ChIP-Seq data, microarray gene expression and gene-level RNA-Seq results from the ", 
                                                     a("Gene Expression Omnibus (GEO).", href="http://www.ncbi.nlm.nih.gov/geo/", target="_blank"),
                                                     " REALGAR facilitates prioritization of genes and experiment design of functional validation studies."),
                                                   p("To use REALGAR, input an official gene symbol or SNP ID, and select tissues, phenotypes, treatments/exposures",
                                                     " and GWAS of interest. The 'Results' tab allows you to visualize and download ", 
                                                     "results for the studies matching your selection criteria. ",
                                                     "The 'Datasets loaded' tab provides more information about the datasets selected. "),br(),
                                                   p("If you use REALGAR in your research, please cite the following papers:"),
                                                   p("Shumyatcher M, Hong R, Levin J, Himes BE.", a("Disease-Specific Integration of Omics Data to Guide Functional Validation of Genetic Associations.",href="http://himeslab.org/wp-content/uploads/2018/06/REALGAR_resubmission_07.06.2017_FINAL_Corrected.pdf", target="_blank"),"AMIA Annu Symp Proc. 2018;2017:1589–1596. 
                        Published 2018 Apr 16. (PMID:",a("29854229).",href="https://www.ncbi.nlm.nih.gov/pubmed/29854229", target="_blank"),"You can refer to the code",a("here.",href="https://github.com/HimesGroup/taffeta",target="_blank")),
                                                   p("Kan M, Shumyatcher M, Diwadkar A, Soliman G, Himes BE.", a("Integration of Transcriptomic Data Identifies Global and 
                         Cell-Specific Asthma-Related Gene Expression Signatures.",href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6371257/pdf/2973744.pdf",target="_blank"),"AMIA Annu Symp Proc. 2018;2018:1338–1347. 
                         Published 2018 Dec 5. (PMID:", a("30815178).",href="https://www.ncbi.nlm.nih.gov/pubmed/30815178", target="_blank"),
                                                     "You can refer to the code",a("here.",href="https://github.com/HimesGroup/raved", target="_blank")),
                                                   #Footer
                                                   tags$footer(img(src="http://public.himeslab.org/rstudio-shiny-logo.png", height=124*.65, width=110.4*.65), 
                                                               "Created with RStudio's ", a("Shiny", href="http://www.rstudio.com/shiny", target="_blank"),
                                                               p("This app was created by Maya Shumyatcher, Mengyuan Kan, Avantika Diwadkar and Blanca Himes at the ", a("Himes Lab.", href="http://himeslab.org/", target="_blank")),style = footstyle)))))
                                                                                                                                                                                                                                   
