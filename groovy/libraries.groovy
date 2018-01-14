import org.jenkinsci.plugins.workflow.libs.LibraryConfiguration
import org.jenkinsci.plugins.workflow.libs.SCMRetriever
import jenkins.model.Jenkins;

import hudson.scm.SCM
import hudson.plugins.git.BranchSpec
import hudson.plugins.git.GitSCM
import hudson.plugins.git.SubmoduleConfig
import hudson.plugins.git.extensions.GitSCMExtension

def globalLibsDesc = Jenkins.instance.getDescriptor("org.jenkinsci.plugins.workflow.libs.GlobalLibraries")


def results = []

def libraries=[
        'my-libs':['defaultVersion':'master', 'implicit':true, 'allowVersionOverride':true, 'scm':[branch: 'master', url:'https://github.com/kenych/jenkins-shared-groovy-lib.git', 'credentialsId': 'gitLabCredentials']]
]

libraries.each { library ->
    def branch = library.value.scm.branch == null ? '*/master' : library.value.scm.branch
    SCM scm = new GitSCM(GitSCM.createRepoList(library.value.scm.url, library.value.scm.credentialsId),
            Collections.singletonList(new BranchSpec(branch)),
            false, Collections.<SubmoduleConfig>emptyList(),
            null, null, Collections.<GitSCMExtension>emptyList())

    SCMRetriever retriever = new SCMRetriever(scm)
    LibraryConfiguration pipeline = new LibraryConfiguration(library.key, retriever)
    pipeline.setDefaultVersion(library.value.defaultVersion)
    pipeline.setImplicit(library.value.implicit)
    pipeline.setAllowVersionOverride(library.value.allowVersionOverride)
    results.add(pipeline)
}
globalLibsDesc.get().setLibraries(results)