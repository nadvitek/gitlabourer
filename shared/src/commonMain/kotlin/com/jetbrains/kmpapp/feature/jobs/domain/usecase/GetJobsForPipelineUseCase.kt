package com.jetbrains.kmpapp.feature.jobs.domain.usecase

import com.jetbrains.kmpapp.feature.jobs.domain.JobsRepository
import com.jetbrains.kmpapp.feature.jobs.domain.model.Bridge
import com.jetbrains.kmpapp.feature.jobs.domain.model.DetailedJob
import com.jetbrains.kmpapp.feature.jobs.domain.model.JobsSection
import com.jetbrains.kmpapp.feature.jobs.domain.model.JobsStream
import io.github.mykhailoliutov.koinexport.core.KoinKmmExport
import kotlinx.coroutines.coroutineScope

@KoinKmmExport
public interface GetJobsForPipelineUseCase {

    @Throws(Throwable::class)
    public suspend operator fun invoke(
        projectId: Int,
        pipelineId: Long
    ): JobsStream
}

internal class GetJobsForPipelineUseCaseImpl(
    private val jobsRepository: JobsRepository
) : GetJobsForPipelineUseCase {

    override suspend fun invoke(
        projectId: Int,
        pipelineId: Long
    ): JobsStream = coroutineScope {
        buildTree(
            currentProjectId = projectId.toLong(),
            pipelineId = pipelineId,
            previousBridge = null
        )
    }

    private suspend fun buildTree(
        currentProjectId: Long,
        pipelineId: Long,
        previousBridge: Bridge?
    ): JobsStream {
        val jobs = runCatching {
            jobsRepository.getJobsForPipeline(
                projectId = currentProjectId.toInt(),
                pipelineId = pipelineId
            )
        }.getOrElse { emptyList() }

        var sections = groupByStageStable(jobs)

        if (sections.isEmpty() && previousBridge != null) {
            sections = listOf(JobsSection(
                stage = previousBridge.stage ?: "no-stage",
                jobs = listOf(DetailedJob(
                    id = 0,
                    status = previousBridge.status,
                    stage = previousBridge.stage.orEmpty(),
                    name = previousBridge.name
                ))
            ))
        }

        println("Sections $sections for pipeline $pipelineId")

        val bridges = runCatching {
            jobsRepository.getBridges(
                projectId = currentProjectId.toInt(),
                pipelineId = pipelineId,
            )
        }.getOrElse { emptyList() }

        val childrenRefs = bridges
            .map { it.downstreamPipeline?.id }

        val downstreams = childrenRefs
            .filterNotNull()
            .takeIf { it.isNotEmpty() }
            ?.map { childPipelineId ->
                buildTree(
                    currentProjectId = currentProjectId,
                    pipelineId = childPipelineId,
                    previousBridge = bridges.firstOrNull { childPipelineId == it.downstreamPipeline?.id }
                )
            }
            .orEmpty()

        return JobsStream(
            pipelineId = pipelineId,
            projectId = currentProjectId,
            sections = sections,
            downstreams = downstreams
        )
    }

    private fun groupByStageStable(jobs: List<DetailedJob>): List<JobsSection> {
        val bucket = linkedMapOf<String, MutableList<DetailedJob>>()
        val defaultStage = "no-stage"
        for (job in jobs) {
            val stage = job.stage ?: defaultStage
            bucket.getOrPut(stage) { mutableListOf() }.add(job)
        }
        return bucket.map { (stage, items) -> JobsSection(stage = stage, jobs = items.toList()) }.asReversed()
    }
}
